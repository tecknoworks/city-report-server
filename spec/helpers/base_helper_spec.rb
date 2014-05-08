require 'spec_helper'

describe BaseHelper do
  include BaseHelper

  it 'should not create an issue' do
    expect {
      doc_issue[:_id].should_not be_nil
    }.to change{ Issue.count }.by 0
  end
end
