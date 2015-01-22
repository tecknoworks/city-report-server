require 'spec_helper'

describe WebController, type: :controller do
  it 'shows sample upload page' do
    get :up
    response.status.should be 200
  end

  it 'shows eula page' do
    get :eula
    response.status.should be 200
  end

  it 'shows about page' do
    get :about
    response.status.should be 200
  end

  it 'shows meta info' do
    get :meta
    response.status.should be 200
    json['body']['categories'].should eq Category.to_api
    json['body']['zones'].should eq Zone.to_api
  end
end
