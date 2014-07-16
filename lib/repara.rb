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

  def self.base_email
    self.config['base_email']
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

  def self.default_eula_language
    self.config['language']['default_eula_language']
  end

  def self.valid_eula_languages
    self.config['language']['valid_eula_languages']
  end

  def self.show_doc?
    self.config['show_doc']
  end

  def self.show_dashboard?
    self.config['show_dashboard']
  end
end
