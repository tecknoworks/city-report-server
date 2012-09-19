require 'spec_helper'

def response_has_status(code)
  JSON.parse(response.body)["status"]["code"].should == code
end

describe IssuesController do
  before :each do
    @issue = FactoryGirl.create(:issue)
    @issue1 = FactoryGirl.create(:issue)
    @issue2 = FactoryGirl.create(:issue)
    @issue_attr = FactoryGirl.attributes_for(:issue)
    @foo_issue = { :foo => "bar" }
  end
  after :each do
    Issue.delete_all
  end

  describe "GET #index" do
    describe "listing existing issues" do
      it "should list all issues" do
        get :index, :format => :json
        categories = JSON.parse(response.body)
        categories["response"]["issues"].to_json.should == [@issue, @issue1, @issue2].to_json
      end

      it "status code should be 200" do
        get :index, :format => :json
        response_has_status(ApiStatus.OK_CODE)
      end
    end
  end


end
