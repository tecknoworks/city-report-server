require 'spec_helper'

describe Geocoder do
  before :each do
    @db_wrap = DbWrapper.new 'spec/thin.yml'
  end

  # TODO write a real test
  it "should geocode stuff" do
    geo = Geocoder.kung_foo 46.7569358, 23.597322
    geo.should == 'Calea Turzii, Cluj-Napoca, Romania'
  end

  it "should not geocode if lat or lon == 0" do
    params = { 'lat' => 0, 'lon' => 0 }
    issue = @db_wrap.create_issue(params)
    issue['address'].should be_nil
  end

  it "should geocode upon creating" do
    params = { 'lat' => 46.7569358, 'lon' => 23.597322 }
    issue = @db_wrap.create_issue(params)
    issue['address'].should == 'Calea Turzii, Cluj-Napoca, Romania'
  end
end
