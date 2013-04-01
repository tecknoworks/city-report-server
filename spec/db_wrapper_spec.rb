require 'spec_helper'

describe DbWrapper do
  before :each do
    @db_wrap = DbWrapper.new 'spec/config.yml'
  end

  it "should load the test yml file" do
    @db_wrap.config['environment'].should  == 'test'
  end

  it "should return an array of issues" do
    @db_wrap.issues.class.should == Array
  end

  it "should create an issue" do
    expect {
      params = {:lat => 0.0, :lon => 0.0, :title => 'problem'}
      @db_wrap.create_issue(params)
    }.to change{@db_wrap.issues.count}.by 1
  end
end
