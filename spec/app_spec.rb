require 'spec_helper'

describe "api" do
  it "should work" do
    get '/'
    last_response.should be_ok
  end

  it "should return valid json" do
    get '/issues'
    last_response.content_type.include?('application/json').should be_true
    expect {
      JSON.parse(last_response.body)
    }.to_not raise_error
  end

  it "should ensure required params are set" do
    post '/issues'
    last_response.status.should == 400

    post '/issues', { :lat => 0.0 }
    last_response.status.should == 400

    post '/issues', { :lat => 0.0, :lon => 0.0 }
    last_response.status.should == 400

    expect {
      post '/issues', { :lat => 0.0, :lon => 0.0, :title => 'hello world'}
      last_response.status.should == 200
    }.to change{ JSON.parse(get('/issues').body).count }.by 1
  end

  it "should return what was created" do
    post '/issues', { :lat => 0.0, :lon => 0.0, :title => 'hello world'}
    JSON.parse(last_response.body)['title'].should == 'hello world'
  end
end
