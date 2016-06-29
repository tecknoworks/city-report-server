ActiveAdmin.register Issue do
  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs do
      f.input :name
      f.input :status, collection: Issue::VALID_STATUSES
      f.input :device_id, required: true
      f.input :lat, input_html: { value: 46.768322 }
      f.input :lon, input_html: { value: 23.595002 }
      f.input :address
      f.input :category, collection: Category.to_api
      f.input :hide, as: :boolean
      f.input :resolve_time
      f.input :vote_counter
      f .input :images_raw, as: :text
      f.input :comments_raw, as: :text
    end
    f.actions
  end

  index do
    selectable_column
    # id_column
    column :name
    column :status
    column :device_id
    column :lat
    column :lon
    column :address
    column :hide
    column :resolve_time
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
      unless params.has_key? 'categories'
        params['categories'] = {}
      end

      unless params.has_key? "commit"
        @category_admin = CategoryAdmin.where(admin_user: current_admin_user)
        @category_admin.each do |c|
          category = Category.find(c.categories_id).name
          params['categories'][category] = category
        end
      end

      @categories = []

      params['categories'].each do |key, value|
        @categories.push value
      end

      @issues = Issue.in(category: @categories)
      if params.has_key? "hidden"
        @issues = @issues.where(hide: params[:hidden])
      end
      @issues = @issues.where(category: params[:category]) if params[:category].present?
      @issues = @issues.where(device_id: params[:device_id]) if params[:device_id].present?
      @issues = @issues.where(status: params[:status]) if params[:status].present?
      @issues = @issues.full_text_search(params[:q]) if params[:q].present?
      @issues = @issues.page(params[:page])
    end
  end

  sidebar :filters, partial: "custom_filters", only: :index #
end
