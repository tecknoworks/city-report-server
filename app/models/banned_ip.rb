# CODE: Remove all whitespace
class BannedIp < BaseModel
  require "resolv"
  
  self.primary_key = 'id'
  
  field :address, type: String
  
  validates :address, presence: true
  
  validate :ip_format
     
  
  protected
  
  def ip_format
    
    self.errors.add(:invalide_ip_format, 'ip invalid ') if !(address =~ Resolv::IPv4::Regex ? true : false )
    self.errors.add(:invalide_ip_format, 'ip invalid ') if Issue.where(address: address).count == 1

  end

end