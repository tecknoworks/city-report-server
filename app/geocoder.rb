class Geocoder
  include HTTParty
  base_uri 'maps.googleapis.com'

  def self.kung_foo lat, lon
    options = {
      :query => {
        :latLng => "#{lat},#{lon}",
        :sensor => false
      }
    }
    get("/maps/api/geocode/json", options).body
  end
end
