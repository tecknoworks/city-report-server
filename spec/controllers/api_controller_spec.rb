require 'spec_helper'

describe ApiController do
  describe "POST #create" do
    describe "with valid params" do
      before :each do
        @category_name = "Gunoi"
        @issue_to_create = FactoryGirl.attributes_for(:issue_no_category)
        @foo_issue = { :foo => "bar" }
      end
      after :each do
        Category.delete_all
      end
      it "should create category on the fly" do
        expect {
          post :create_issue_auto_category, :issue => @issue_to_create, :category_name => @category_name, :format => :json
        }.to change(Category, :count).by(1)
      end
      it "should create issue" do
        expect {
          post :create_issue_auto_category, :issue => @issue_to_create, :category_name => @category_name, :format => :json
        }.to change(Issue, :count).by(1)
      end

      it "should have response code 200" do
        post :create_issue_auto_category, :issue => @issue_to_create, :category_name => @category_name, :format => :json
        response_has_status(ApiStatus.OK_CODE)
      end

      it "should match what we sent" do
        post :create_issue_auto_category, :issue => @issue_to_create, :category_name => @category_name, :format => :json

        recieved_issue = JSON.parse(response.body)["response"]["issue"]
        sent_issue = { "id" => Issue.last.id, "title" => @issue_to_create[:title]  }

        sent_issue["id"].should == recieved_issue["id"]
        sent_issue["title"].should == recieved_issue["title"]
      end

      it "should have category with given name" do
        post :create_issue_auto_category, :issue => @issue_to_create, :category_name => @category_name, :format => :json
        recieved_issue = JSON.parse(response.body)["response"]["issue"]
        Category.find(recieved_issue["category_id"]).name.should == @category_name
      end
    end

    describe "with good parent params, but no other params" do
      it "should return JSON with response code Bad Request(400)" do
        post :create_issue_auto_category, :issue => @foo_issue, :category_name => @category_name, :format => :json
        response_has_status(ApiStatus.BAD_REQUEST_CODE)
      end
      it "should return JSON with response code Bad Request(400) if no category name sent" do
        post :create_issue_auto_category, :issue => @issue_to_create, :category_name => nil, :format => :json
        response_has_status(ApiStatus.BAD_REQUEST_CODE)
      end
    end

    describe "with no params" do
      it "should return JSON with response code Bad Request(400)" do
        post :create_issue_auto_category, :foo => @foo_issue, :format => :json
        response_has_status(ApiStatus.BAD_REQUEST_CODE)
      end
    end
  end
end
