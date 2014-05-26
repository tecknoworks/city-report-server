class Repara
  def self.config
    APP_CONFIG
  end

  def self.app_name
    self.config['app_name']
  end

  def self.categories
    self.config['meta']['categories']
  end

  def self.base_url
    self.config['base_url']
  end

  def self.string_max_length
    self.config['string_max_length']
  end

  def self.name_max_length
    string_max_length['name']
  end

  def self.comments_max_length
    string_max_length['comments']
  end

  def self.address_max_length
    string_max_length['address']
  end

  def self.map_center
    self.config['map_center']
  end
end
