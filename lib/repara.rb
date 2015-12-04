# All sorts of config options
class Repara
  def self.config
    APP_CONFIG
  end

  def self.app_name
    config['app_name']
  end

  def self.base_url
    config['base_url']
  end

  def self.base_email
    config['base_email']
  end

  def self.string_max_length
    config['string_max_length']
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
    config['map_center']
  end

  def self.default_eula_language
    config['language']['default_eula_language']
  end

  def self.valid_eula_languages
    config['language']['valid_eula_languages']
  end

  def self.show_doc?
    config['show_doc']
  end

  def self.max_distance_validator
    config['max_distance_validator']
  end

  def self.max_distance_to_map_center
    config['max_distance_to_map_center']
  end

  def self.map_center_lat
    map_center['lat']
  end

  def self.map_center_lon
    map_center['lon']
  end
end
