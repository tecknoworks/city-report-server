require 'spec_helper'

describe Category do
  before { @category = FactoryGirl.create(:category) }

  it "should have a relationship with Issue(s)" do
    @category.issues.class.should == Array
  end

end
