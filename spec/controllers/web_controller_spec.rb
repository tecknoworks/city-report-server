require 'spec_helper'

describe WebController do
  it "has a home page" do
    get '/'
    last_response.should be_ok
  end

  it 'serves the doc' do
    get '/doc'
    last_response.should be_ok
  end

  it 'has an admin page' do
    get '/admin'
    last_response.should be_ok
  end
end
