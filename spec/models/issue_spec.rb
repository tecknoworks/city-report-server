require 'spec_helper'

describe Issue do

  it "should have one Category" do
    @issue = FactoryGirl.create(:issue)
    @issue.category.class.should == Category
  end
  
  it "should return nil if no Category is set" do
    @issue = FactoryGirl.create(:issue_no_category)
    @issue.category.nil?.should == true
  end

end
