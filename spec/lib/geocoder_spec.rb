require 'spec_helper'

describe Geocoder do

  it 'return info zone' do
    expect(Geocoder.get_info_zone(46.76714653871027, 23.586959838867188)['results'][0]['address_components'][1]['long_name'].to_s).to eq "Strada Republicii"
    expect(Geocoder.get_info_zone(46.78031411656016, 23.576552867889404)['results'][0]['address_components'][1]['long_name'].to_s).to eq "Gruia"
  end

end
