# Uses google geocoding
class Geocoder
  include HTTParty
  base_uri 'maps.googleapis.com'

  # TODO: think of a good name
  def self.kung_foo(lat, lon)
    return '' if lat.to_f == 0.0 || lon.to_f == 0.0

    geo = get("/maps/api/geocode/json?latlng=#{lat},#{lon}&sensor=false").body
    json = JSON.parse(geo)
    return '' if json['status'] != 'OK'

    return json['results'][0]['formatted_address']
  rescue
    return ''
  end
end
