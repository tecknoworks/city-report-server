# Uses google geocoding
class Geocoder
  include HTTParty
  base_uri 'maps.googleapis.com'
  
  def self.get_info_zone(lat, lon)
    geo = get("/maps/api/geocode/json?latlng=#{lat},#{lon}&sensor=false").body
    json = JSON.parse(geo)
    return json
  end

  # TODO: think of a good name
  def self.kung_foo(lat, lon)
    return '' if lat.to_f == 0.0 || lon.to_f == 0.0

    json = self.get_info_zone(lat, lon)
    return '' if json['status'] != 'OK'

    return json['results'][0]['formatted_address']
  rescue
    return ''
  end
end

#verif in ce cartier este un issue