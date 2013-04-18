require 'spec_helper'

describe Geocoder do
  # TODO write a real test
  it "should geocode stuff" do
    geo = Geocoder.kung_foo 46.7569358, 23.597322
    geo.should == 'Calea Turzii, Cluj-Napoca, Romania'
  end
end
