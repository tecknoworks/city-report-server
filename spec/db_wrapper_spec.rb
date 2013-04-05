require 'spec_helper'

describe DbWrapper do
  before :each do
    @db_wrap = DbWrapper.new 'spec/config.yml'
  end

  after :each do
    @db_wrap.db['issues'].remove
  end

  it "should load the test yml file" do
    @db_wrap.config['environment'].should  == 'test'
  end

  it "should return an array of issues" do
    @db_wrap.issues.class.should == Array
  end

  it "should create an issue" do
    expect {
      params = {:lat => 0.0, :lon => 0.0, :title => 'problem'}
      @db_wrap.create_issue(params)
    }.to change{@db_wrap.issues.count}.by 1
  end

  it "should return a valid list of json objects" do
    params = {:lat => 0.0, :lon => 0.0, :title => 'problem'}
    @db_wrap.create_issue(params)
    @db_wrap.issues.last['id'].should_not == nil
    @db_wrap.issues.last['_id'].should == nil
  end

  it "should not save the 'image' param" do
    params = { :lat => 0.0, :image => 'asd' }
    @db_wrap.create_issue(params)
    @db_wrap.issues.last['image'].should == nil
    @db_wrap.issues.last['lat'].should_not == nil
  end

  it "should have image_upload_path loaded for test env" do
    @db_wrap.config['image_upload_path'].should == 'spec/public/system/uploads'
  end

  it "should save an image" do
    expect {
      @db_wrap.save_image({
        'image' => {
          :tempfile => Rack::Test::UploadedFile.new('spec/logo.png', 'image/png')
        }
      })
    }.to change{
      iup = File.join(@db_wrap.config['image_upload_path'], '*')
      Dir[iup].count
    }.by 1
  end
end
