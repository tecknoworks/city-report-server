class BannedIp < BaseModel
  
  field :address, type: String
  
  validates :address, presence: true
  
end