require 'spec_helper'

describe ImagesController do
  let(:filename) { 'test.png' }
  let(:non_png_filename) { 'test.tar.gz' }
  let(:the_file) do
    Rack::Test::UploadedFile.new('spec/assets/logo.png', 'image/png')
  end

  context 'post' do
    it 'keep track of uploaded images in the database' do
      Image.any_instance.stub(:storage_filename).and_return(filename)
      expect do
        post :create, 'image' => the_file
      end.to change { Image.count }.by 1
    end

    it 'should give an error when image param is missing' do
      post :create
      response.status.should be RequestCodes::BAD_REQUEST
    end

    it 'should show the url and thumb_url' do
      Image.any_instance.stub(:storage_filename).and_return(filename)
      post :create, 'image' => the_file
      response.status.should be 200

      json['body'].should_not be_nil
      json['body']['_id'].should be_nil
      json['body']['url'].should_not be_nil
      json['body']['thumb_url'].should_not be_nil
    end

    it 'should upload files' do
      Image.any_instance.stub(:storage_filename).and_return(filename)

      # prepare env
      path_to_file = "public/images/uploads/original/#{filename}"
      File.delete(path_to_file) if File.exist?(path_to_file)
      File.exist?(path_to_file).should be_false

      post :create, 'image' => the_file
      File.exist?(path_to_file).should be_true

      # cleanup
      File.delete(path_to_file)
    end

    it 'should only allow png images' do
      ImagesController.any_instance.stub(:serialize_filename)
        .and_return(non_png_filename)

      non_png = Rack::Test::UploadedFile.new('spec/assets/' + non_png_filename)
      post :create, 'image' => non_png
      response.status.should be RequestCodes::BAD_REQUEST
      json['code'].should be RequestCodes::INVALID_IMAGE_FORMAT
    end
  end
end
