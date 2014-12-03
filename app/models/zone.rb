class Zone < BaseModel
  include MetaToApi

  self.primary_key = 'id'

  field :name, type: String

  validates :name, presence: true
end
