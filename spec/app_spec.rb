require 'spec_helper'

describe "Wpp" do
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
end
