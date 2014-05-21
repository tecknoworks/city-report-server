require 'spec_helper'

describe WebController do
  it 'shows doc page' do
    last_response = get :doc
    last_response.status.should == 200
  end

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
    JSON.parse(last_response.body).should == Repara.config['meta']
  end
end
