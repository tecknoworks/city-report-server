class BannedIp < BaseModel
  
  self.primary_key = 'id'
  
  field :address, type: String
  
  validates :address, presence: true
  
  validate :ip_format
     
  
  protected
  
  def ip_format
    ip = []
    if address
      ip = address.split('.')
    end
    
    self.errors.add(:invalide_ip_format, 'ip invalid') if ip.count != 4
 
    for i in ip
        self.errors.add(:invalide_ip_format, 'ip invalid') if i.to_i<0 or i.to_i > 255
    end
    
    def numeric?(number)
      Integer(number) != nil rescue false
    end
  
    for num in ip
        self.errors.add(:invalide_ip_format, 'ip invalid') if !numeric?(num)
    end

  end
  
end