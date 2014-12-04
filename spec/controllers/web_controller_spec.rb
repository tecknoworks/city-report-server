require 'spec_helper'

describe WebController do
  it 'shows sample upload page' do
    get :up
    response.status.should == 200
  end

  it 'shows eula page' do
    get :eula
    response.status.should == 200
  end

  it 'shows about page' do
    get :about
    response.status.should == 200
  end

  it 'shows meta info' do
    get :meta
    response.status.should == 200
    json['body']['categories'].should == Category.to_api
    json['body']['zones'].should == Zone.to_api
  end
end
