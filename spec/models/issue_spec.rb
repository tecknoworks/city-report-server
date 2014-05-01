require 'spec_helper'

describe Issue do
  it 'should use test db' do
    # repara-test can be found in config/mongoid.yml
    Mongoid.default_session.options[:database].should == 'repara-test'
  end

  it 'should create an issue' do
    expect {
      i = Issue.new(name: 'foo', lat: 1, lon: 2, category: 'altele')
      i.save
      i.images.should be_empty
      i.errors.should be_empty
    }.to change{ Issue.count }.by 1
  end
end
