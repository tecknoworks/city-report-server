# Uses google geocoding
class Geocoder
  include HTTParty
  base_uri 'maps.googleapis.com'

  def self.get_info_zone(lat, lon)
    return '' if lat.to_f == 0.0 || lon.to_f == 0.0
    geo = get("/maps/api/geocode/json?latlng=#{lat},#{lon}&sensor=false").body
    json = JSON.parse(geo)
    json['status'] == 'OK' ? json : ''
  end
  
  # TODO: think of a good name
  def self.kung_foo(lat, lon)
    json = self.get_info_zone(lat, lon)
    return json['results'][0]['formatted_address']
  rescue
    return ''
  end
end
