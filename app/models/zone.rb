class Zone < BaseModel

  self.primary_key = 'id'

  field :name, type: String

  validates :name, presence: true

  def self.to_api
    self.all.collect{|cat| cat.name}
  end
end
