ActiveAdmin.register Issue do
  form do |f|
    f.semantic_errors *f.object.errors.keys

    f.inputs do
      f.input :name
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
    column :lat
    column :lon
    column :address
    column :category
    column :vote_counter
    column 'Image' do |issue|
      issue.images.count
    end
    column 'Comments' do |issue|
      issue.comments.count
    end
    actions
  end
end
