class Category < BaseModel

  self.primary_key = 'id'

  field :name, type: String
  field :resolve_time, type: Integer, default: 0

  validates :name, presence: true

  def self.to_api
    self.all.collect{|cat| cat.name}
  end
end
