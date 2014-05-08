require 'spec_helper'

describe ImagesController do
  let(:filename) { 'test.png' }
  let(:non_png_filename) { 'test.tar.gz' }

  it 'should upload files' do
    ImagesController.any_instance.stub(:serialize_filename).and_return(filename)

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

    path_to_file = "public/images/uploads/#{non_png_filename}"
    post '/', { 'image' => Rack::Test::UploadedFile.new('spec/assets/' + non_png_filename) }
    last_response.status.should == 400
    JSON.parse(last_response.body)['code'].should == RequestCodes::INVALID_IMAGE_FORMAT
  end
end
