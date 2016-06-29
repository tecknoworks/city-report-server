class Category < BaseModel
  include MetaToApi

  self.primary_key = 'id'

  has_many :category_admin

  field :name, type: String
  field :min_time, type: Integer, default: 0
  field :max_time, type: Integer, default: 0

  validates :name, presence: true
  validates :min_time, :numericality => { :greater_than_or_equal_to => 0 }
  validates :max_time, :numericality => { :greater_than_or_equal_to => 0 }
end
