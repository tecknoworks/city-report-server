class Category < BaseModel
  include MetaToApi

  self.primary_key = 'id'

  has_many :category_admin

  field :name, type: String
  field :resolve_time, type: Integer, default: 0

  validates :name, presence: true
end
