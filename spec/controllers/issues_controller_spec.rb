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

  describe "POST #create" do
    describe "with valid params" do
      before :each do
        category = FactoryGirl.create(:category)
        @issue_to_create = FactoryGirl.attributes_for(:issue, :category_id => category.id)
      end
      after :each do
        Category.delete_all
      end
      it "should create issue" do
        expect {
          post :create, :issue => @issue_to_create, :format => :json
        }.to change(Issue, :count).by(1)
      end

      it "should have response code 200" do
        post :create, :issue => @issue_to_create, :format => :json
        response_has_status(ApiStatus.OK_CODE)
      end

      it "should match what we sent" do
        post :create, :issue => @issue_to_create, :format => :json

        recieved_issue = JSON.parse(response.body)["response"]["issue"]
        sent_issue = { "id" => Issue.last.id, "title" => @issue_attr[:title]  }

        sent_issue["id"].should == recieved_issue["id"]
        sent_issue["title"].should == recieved_issue["title"]
      end
    end

    describe "with good params, but no other params" do
      it "should return JSON with response code Bad Request(400)" do
        post :create, :issue => @foo_issue, :format => :json
        response_has_status(ApiStatus.BAD_REQUEST_CODE)
      end
    end

    describe "with no params" do
      it "should return JSON with response code Bad Request(400)" do
        post :create, :foo => @foo_issue, :format => :json
        response_has_status(ApiStatus.BAD_REQUEST_CODE)
      end
    end
  end

end
