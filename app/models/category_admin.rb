class CategoryAdmin
  include Mongoid::Document
  self.primary_key = 'id'

  belongs_to :categories
  belongs_to :admin_user
end
