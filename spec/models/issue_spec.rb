require 'spec_helper'

describe Issue do
  let(:category) { Repara.categories.last }

  it 'should use test db' do
    # repara-test can be found in config/mongoid.yml
    Mongoid.default_session.options[:database].should == 'repara-test'
  end

  it 'should create an issue' do
    expect {
      i = Issue.new(name: 'foo', category: category)
      i.save
      i.lat.should == 0
      i.lon.should == 0
      i.images.should be_empty
      i.errors.should be_empty
    }.to change{ Issue.count }.by 1
  end
end
