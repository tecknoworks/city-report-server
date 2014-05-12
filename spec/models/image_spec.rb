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
end
