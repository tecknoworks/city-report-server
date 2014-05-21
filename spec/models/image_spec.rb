require 'spec_helper'

describe Image do

  context 'validation' do
    it 'allows only png images' do
      i = Image.create(original_filename: 'foo.png')
      i.storage_filename.should_not be_nil
      i.storage_path.should_not be_nil
      i.storage_thumb_path.should_not be_nil
      i.url.should_not be_nil
      i.thumb_url.should_not be_nil
    end
  end

  context '#to_api' do
    it 'filters out irrelevant information' do
      api_keys = Image.create(original_filename: 'foo.png').to_api.keys
      api_keys.length.should == 2
      api_keys.include?(:url).should be_true
      api_keys.include?(:thumb_url).should be_true
    end
  end
end
