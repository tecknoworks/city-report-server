class Category < BaseModel
  include MetaToApi

  self.primary_key = 'id'

  field :name, type: String
  field :resolve_time, type: Integer, default: 0

  validates :name, presence: true
end
