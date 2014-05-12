require 'spec_helper'

describe Image do

  it 'should only allow png images' do
    i = Image.new(original_filename: 'foo.png')
    i.save
    i.storage_filename.should_not be_nil
    i.storage_path.should_not be_nil
    i.storage_thumb_path.should_not be_nil
    i.url.should_not be_nil
    i.thumb_url.should_not be_nil
  end

  it 'only displays relevant info when using to_api' do
    api_keys = Image.create(original_filename: 'foo.png').to_api.keys
    api_keys.length.should == 2
    api_keys.include?(:url).should be_true
    api_keys.include?(:thumb_url).should be_true
  end
end
