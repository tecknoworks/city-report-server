require 'spec_helper'

describe IssuesController do
  it 'should create an issue' do
    post '/', {name: 'bar'}
    # p last_response.body
  end
end
