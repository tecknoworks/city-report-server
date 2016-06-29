ActiveAdmin.register CategoryAdmin do
  index do
    selectable_column
    id_column
    column :admin_user
    column :categories
    actions
  end

  form do |f|
    f.inputs "Admin Details" do
      f.input :admin_user, as: :select, collection: AdminUser.all.map { |u| ["#{u.email}", u.id] }
      f.input :categories
    end
    f.actions
  end
end
