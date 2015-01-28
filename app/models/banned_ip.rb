# CODE: Remove all whitespace
class BannedIp < BaseModel
  require "resolv"
  
  self.primary_key = 'id'
  
  field :address, type: String
  field :ip_v4, type: String
  field :ip_v6, type: String
  
  validates :address, presence: true
  
  validate :ip_format

  def ip_v4?
    address =~ Resolv::IPv4::Regex ? true : false
  end

  def ip_v6?
    address =~ Resolv::IPv6::Regex ? true : false
  end

  protected

  def ip_format

    if !ip_v4? and !ip_v6?
      self.errors.add(:invaide_ip_format, 'ip invalid')
    end

    self.errors.add(:invalide_ip_format, 'ip invalid ') if Issue.where(address: address).count == 1

  end

end