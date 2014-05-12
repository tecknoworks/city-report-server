require 'spec_helper'

describe ImagesController do
  let(:filename) { 'test.png' }
  let(:non_png_filename) { 'test.tar.gz' }

  it 'keep track of uploaded images in the database' do
    Image.any_instance.stub(:storage_filename).and_return(filename)
    expect {
      post '/', { 'image' => Rack::Test::UploadedFile.new('spec/assets/logo.png', 'image/png') }
    }.to change { Image.count }.by 1
  end

  it 'should give an error when image param is missing' do
    post '/'
    last_response.status.should == RequestCodes::BAD_REQUEST
  end

  it 'should show the url and thumb_url' do
    Image.any_instance.stub(:storage_filename).and_return(filename)
    post '/', { 'image' => Rack::Test::UploadedFile.new('spec/assets/logo.png', 'image/png') }

    image = JSON.parse(last_response.body)
    image['body'].should_not be_nil
    last_response.status.should == 200
    image = image['body']
    image['_id'].should be_nil
    image['url'].should_not be_nil
    image['thumb_url'].should_not be_nil
  end

  it 'should upload files' do
    Image.any_instance.stub(:storage_filename).and_return(filename)

    # prepare env
    path_to_file = "public/images/uploads/original/#{filename}"
    File.delete(path_to_file) if File.exist?(path_to_file)
    File.exists?(path_to_file).should be_false

    post '/', { 'image' => Rack::Test::UploadedFile.new('spec/assets/logo.png', 'image/png') }
    File.exists?(path_to_file).should be_true

    # cleanup
    File.delete(path_to_file)
  end

  it 'should only allow png images' do
    ImagesController.any_instance.stub(:serialize_filename).and_return(non_png_filename)

    post '/', { 'image' => Rack::Test::UploadedFile.new('spec/assets/' + non_png_filename) }
    last_response.status.should == RequestCodes::BAD_REQUEST
    JSON.parse(last_response.body)['code'].should == RequestCodes::INVALID_IMAGE_FORMAT
  end
end
