require 'spec_helper'

describe BaseController do
  it 'should run in test env' do
    app.settings.environment.should == :test
    app.settings.config['env'].should == 'test'
  end
end

describe WelcomeController do
  it "should allow accessing the home page" do
    get '/'
    last_response.should be_ok
  end

  it 'should allow the meta requests' do
    get '/meta'
    last_response.should be_ok
    json_data = JSON.parse(last_response.body)
    json_data.should == app.settings.config['meta']
  end

  it 'should serve the doc' do
    get '/doc'
    last_response.should be_ok
  end
end
