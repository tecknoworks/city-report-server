require 'spec_helper'

describe BaseHelper do
  include BaseHelper

  context '#doc_issue' do
    it 'should not create an issue' do
      expect {
        doc_issue[:_id].should_not be_nil
      }.to change{ Issue.count }.by 0
    end
  end

  context '#doc_image' do
    it 'should not create an image' do
      expect {
        doc_image[:url].should_not be_nil
        doc_image[:thumb_url].should_not be_nil
      }.to change{ Image.count }.by 0
    end
  end
end
