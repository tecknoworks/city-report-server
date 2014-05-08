require 'spec_helper'

describe BaseHelper do
  include BaseHelper

  it 'should not create an issue' do
    expect {
      p doc_issue
      i = Issue.new(name: 'name', address: '', lat: 0, lon: 0, created_at: Time.now, updated_at: Time.now, category: Repara.categories.last)
      i[:_id].should_not be_nil
    }.to change{ Issue.count}.by 0
  end
end
