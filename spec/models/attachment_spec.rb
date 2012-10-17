require 'spec_helper'

describe Attachment do

  it "should belong_to issue" do
    @attachment = FactoryGirl.create(:attachment)
    lambda {@attachment.issue}.should_not raise_error
  end

end
