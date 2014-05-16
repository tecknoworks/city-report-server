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

  it 'shows statistics' do
    get '/stats'
    last_response.should be_ok
  end
end
