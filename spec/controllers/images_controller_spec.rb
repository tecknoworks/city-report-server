require 'spec_helper'

describe ImagesController do
  let(:filename) { 'test.png' }

  it 'should upload files' do
    ImagesController.any_instance.stub(:serialize_filename).and_return(filename)

    # prepare env
    path_to_file = "public/images/uploads/#{filename}"
    File.delete(path_to_file) if File.exist?(path_to_file)
    File.exists?(path_to_file).should be_false

    post '/', { 'image' => Rack::Test::UploadedFile.new('spec/assets/logo.png', 'image/png') }
    File.exists?(path_to_file).should be_true

    # cleanup
    File.delete(path_to_file)
  end
end
