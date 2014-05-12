require 'spec_helper'

describe Issue do
  let(:category) { Repara.categories.last }

  it 'should use test db' do
    # repara-test can be found in config/mongoid.yml
    Mongoid.default_session.options[:database].should == 'repara-test'
  end

  it 'knows if it is invalid before save' do
    Issue.new(name: 'foo', category: category, lat: 0, lon: 0).valid?.should be_false
  end

  it 'should create an issue' do
    expect {
      i = Issue.new(name: 'foo', category: category, lat: 0, lon: 0, images: ['http://www.foo.com:80/bar.png'])
      i.save
      i.lat.should == 0
      i.lon.should == 0
      i.images.should_not be_empty
      i.errors.should be_empty
    }.to change{ Issue.count }.by 1
  end

  it 'searches' do
    search_term = 'foo'
    issues = Issue.search(search_term)
    issues.each do |i|
      p i
    end
  end
end
