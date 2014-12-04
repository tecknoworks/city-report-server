require 'spec_helper'

describe WebController do
  it 'shows sample upload page' do
    last_response = get :up
    last_response.status.should == 200
  end

  it 'shows eula page' do
    last_response = get :eula
    last_response.status.should == 200
  end

  it 'shows about page' do
    last_response = get :about
    last_response.status.should == 200
  end

  it 'shows meta info' do
    last_response = get :meta
    last_response.status.should == 200
    JSON.parse(last_response.body)['categories'].should == Category.to_api
    JSON.parse(last_response.body)['zones'].should == Zone.to_api
  end
end
