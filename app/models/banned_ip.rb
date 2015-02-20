class BannedIp < BaseModel
  require "resolv"

  self.primary_key = 'id'

  field :address, type: String

  validates :address, presence: true
  validates :address, uniqueness: true
  
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
      self.errors.add(:invaide_ip_format, 'ip should either be v4 or v6')
    end
  end

end

class River < BaseModel
  require "resolv"

  self.primary_key = 'id'

  field :name, type: String
  field :length, type: Integer
  validates :address, presence: true
  validates :address, uniqueness: true
  
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
      self.errors.add(:invaide_ip_format, 'ip should either be v4 or v6')
    end
  end

end
