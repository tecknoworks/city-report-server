require 'spec_helper'

def issue_count
  JSON.parse(get('/issues').body).count
end

describe "api" do
  it "should work" do
    get '/'
    last_response.should be_ok
  end

  it "should return valid attributes" do
    get '/attributes'
    last_response.should be_ok
    r = JSON.parse(last_response.body)
    r['attributes'].class.should == Array
    r['attributes'].include?('id').should be_true
    r['categories'].should_not be_nil
  end

  it "should not allow titles bigger than 141 characters" do
    expect {
      post '/issues', { :lat => 46.768322, :lon => 23.595002, :title => 'for aiur'}

      last_response.status.should == 200
    }.to change{ issue_count }.by 1

    expect {
      post '/issues', { :lat => 46.868322, :lon => 23.695002, :title => 'a' * 141}
      last_response.status.should == 200
    }.to change{ issue_count }.by 1

    expect {
      post '/issues', { :lat => 0.0, :lon => 0.0, :title => 'a' * 142}
      last_response.status.should == 400
    }.to change{ issue_count }.by 0
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
      post '/issues', { :lat => 0.0, :lon => 0.0, :title => 'super mario'}
      last_response.status.should == 200
    }.to change{ issue_count }.by 1
  end

  it "should return what was created" do
    post '/issues', { :lat => 0.0, :lon => 0.0, :title => 'hello world'}
    JSON.parse(last_response.body)['title'].should == 'hello world'
  end

  it "should not save files when posting to /issues" do
    file = Rack::Test::UploadedFile.new('spec/logo.png', 'image/png')
    post '/issues', { :lat => 0.0, :lon => 0.0, :title => 'with image', :image => file }
    last_response.should be_ok
    JSON.parse(last_response.body)['images'].should == nil
  end

  it "should update an issue" do
    post '/issues', { :lat => 1.0, :lon => 2.0, :title => 'super mario'}
    issue = JSON.parse(last_response.body)
    
    put '/issues', { :lat => 4.0, :lon => 3.3, :title => 'super mario' }
    last_response.should_not be_ok

    put '/issues', { :lat => 4.0, :lon => 3.3, :title => 'super mario', 'id' => issue['id'] }
    issue = JSON.parse(last_response.body)
    issue['lat'].should == "4.0"
  end

  it "should post an image" do
    file = Rack::Test::UploadedFile.new('spec/logo.png', 'image/png')
    post '/images', { :image => file }
    JSON.parse(last_response.body)['url'].should == "/system/uploads/0.png"
  end

  it "should return issues near me" do
    get '/near_me'
  end

  it "should be able to add an item to an array" do
    post '/issues', { :lat => 0.0, :lon => 0.0, :title => 'super mario bros'}
    issue = JSON.parse(last_response.body)

    put '/add_to', {}
    last_response.status.should == 400

    put '/add_to', {:id => issue['id'] }
    last_response.status.should == 400

    put '/add_to', {:id => issue['id'], :key => 'key'}
    last_response.status.should == 400

    put '/add_to', {:id => issue['id'], :key => 'key', :value => 'value' }
    last_response.status.should == 200
    new_issue = JSON.parse(last_response.body)
    new_issue['key'].should == ['value']
  end
end
