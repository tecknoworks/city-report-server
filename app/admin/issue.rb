ActiveAdmin.register Issue do
  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs do
      f.input :name
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
      hash = {}
      hash[:name] = params[:name] if params[:name].present?
      hash[:category] = params[:category] if params[:category].present?
      @issues = Issue.where(hash).page(params[:page])
    end
  end

  sidebar :filter do
    Category.to_api.each do |cat|
      para link_to(cat, admin_issues_path + "?category=#{cat}")
    end
  end
end
