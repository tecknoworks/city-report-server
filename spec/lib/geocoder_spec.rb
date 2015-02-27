require 'spec_helper'

describe Geocoder do

  it 'return info zone' do 
    expect(Geocoder.get_info_zone(46.76714653871027, 23.586959838867188)['results'][0]['address_components'][1]['long_name'].to_s).to eq "Strada Republicii"
  end

  it 'return locality' do
    expect(Geocoder.kung_foo(46.777331119287105, 23.614468574523926).to_s).to eq "Piața Mărăști 3, Cluj-Napoca 400000, Romania"
    expect(Geocoder.kung_foo(46.76267823616486, 23.605241775512695).to_s).to eq "Aleea Muscel 2, Cluj-Napoca 400000, Romania"
    expect(Geocoder.kung_foo(46.779667569602815, 23.5821533203125).to_s).to eq "Strada Emil Racoviță 59, Cluj-Napoca 400000, Romania"
  end

end
