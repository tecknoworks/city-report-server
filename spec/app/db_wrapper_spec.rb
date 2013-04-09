require 'spec_helper'

describe DbWrapper do
  before :each do
    @db_wrap = DbWrapper.new 'spec/thin.yml'
  end

  it "should load the test yml file" do
    @db_wrap.config['environment'].should  == 'test'
  end

  it "should return an array of issues" do
    @db_wrap.issues.class.should == Array
  end

  it "should create an issue" do
    expect {
      params = {:lat => 30.0, :lon => 30.0, :title => 'problem'}
      @db_wrap.create_issue(params)
    }.to change{@db_wrap.issues.count}.by 1
  end

  it "should return a valid list of json objects" do
    params = {:lat => 31.0, :lon => 31.0, :title => 'problem'}
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

  it "should correctly show image_path" do
    iup = @db_wrap.config['image_upload_path']
    count = Dir[File.join(iup, '*')].count.to_s
    img_path = File.join(iup, count + '.png')
    img_path == @db_wrap.image_path
  end

  it "should convert from image_path to image_url_path" do
    image_path = @db_wrap.image_path
    @db_wrap.image_url_path(image_path).should == "/system/uploads/0.png"
    @db_wrap.image_url_path("spec/public/system/uploads/0.png").should == "/system/uploads/0.png"
    @db_wrap.image_url_path("public/system/uploads/0.png").should == "/system/uploads/0.png"
  end

  it "should save an image" do
    expect {
      @db_wrap.save_image({
        'image' => {
          :tempfile => Rack::Test::UploadedFile.new('spec/logo.png', 'image/png')
        }
      })
    }.to change {
      iup = File.join(@db_wrap.config['image_upload_path'], '*')
      Dir[iup].count
    }.by 1
  end

  it "should find an issue by id" do
    params = { :lat => 4.0, :image => 'asd' }
    issue = @db_wrap.create_issue(params)

    @db_wrap.find_issue(issue['id'])['lat'].should == 4.0
  end

  it "should update an issue" do
    params = { 'lat' => 1.0, 'image' => 'asd' }
    issue = @db_wrap.create_issue(params)

    new_params = { 'lat' => 2.0, 'id' => issue['id'] }
    updated_issue = @db_wrap.update_issue(new_params)
    updated_issue['lat'].should == 2.0
  end

  it "should add an image to the array" do
    file = Rack::Test::UploadedFile.new('spec/logo.png', 'image/png')
    params = { 'lat' => 1.0, 'image' => { :tempfile => file } }

    params = @db_wrap.save_image(params)
    @db_wrap.save_image(params)['images'].length.should == 2
  end

end
