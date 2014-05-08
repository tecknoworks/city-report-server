require 'spec_helper'

describe WelcomeController do
  it "should allow accessing the home page" do
    get '/'
    last_response.should be_ok
  end

  it 'should serve the doc' do
    get '/doc'
    last_response.should be_ok
  end
end
