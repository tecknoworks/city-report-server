ActiveAdmin.register Issue do
  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs do
      f.input :name
      f.input :status, collection: Issue::VALID_STATUSES
      f.input :device_id
      f.input :lat, input_html: { value: 46.768322 }
      f.input :lon, input_html: { value: 23.595002 }
      f.input :address
      f.input :category, collection: Category.to_api
      f.input :vote_counter
      f.input :images_raw, as: :text
      f.input :comments_raw, as: :text
    end
    f.actions
  end

  index do
    id_column
    column :name
    column :status
    column :device_id
    column :lat
    column :lon
    column :address
    column :category
    column :vote_counter
    column 'Images' do |issue|
      issue.images.count
    end
    column 'Comments' do |issue|
      issue.comments.count
    end
    actions
  end

  controller do
    def index
      @issues = Issue.all
      @issues = @issues.where(category: params[:category]) if params[:category].present?
      @issues = @issues.where(device_id: params[:device_id]) if params[:device_id].present?
      @issues = @issues.where(status: params[:status]) if params[:status].present?
      @issues = @issues.full_text_search(params[:q]) if params[:q].present?

      @issues = @issues.page(params[:page])
    end
  end

  sidebar :filters, partial: "custom_filters", only: :index
end
