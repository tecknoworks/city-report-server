require 'spec_helper'

def response_has_status(code)
  JSON.parse(response.body)["status"]["code"].should == code
end

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

  describe "PUT #update" do
    before :each do
      @issue = FactoryGirl.create(:issue)
      @foo_issue = { :foo => "bar" }
      @issue_title = "Gunoi in fata statiei de autobuz"
      @issue_latitude = 45.323
      @issue_longitude = 43.3232
      @new_category_name = "Panacotari"
      @edited_issue = FactoryGirl.attributes_for(:issue_no_category, :title => @issue_title,
                                                         :latitude => @issue_latitude,
                                                         :longitude => @issue_longitude)
    end

    describe "with valid params and existing model" do
      it "should modifiy the issue" do
        put :edit_issue_auto_category, :id => @issue, :issue => @edited_issue, :category_name => @new_category_name, :format => :json
        @issue.reload
        @issue.title.should == @issue_title
        @issue.latitude.should == @issue_latitude
        @issue.longitude.should == @issue_longitude
        Category.find(@issue.category_id).name.should == @new_category_name
      end

      it "should return respone code 200" do
        put :edit_issue_auto_category, :id => @issue, :issue => @edited_issue, :category_name => @new_category_name, :format => :json
        response_has_status(ApiStatus.OK_CODE)
      end
    end

    describe "with bad params on existing model" do
      it "should return response code 200(request) if at least one param is ok" do
        put :edit_issue_auto_category, :id => @issue, :issue => @foo_issue, :category_name => @new_category_name, :format => :json
        response_has_status(ApiStatus.OK_CODE)
      end
      it "should return response code 400(bad request), if no param (that includes category_name param)" do
        put :edit_issue_auto_category, :id => @issue, :issue => @foo_issue, :category_name => nil, :format => :json
        response_has_status(ApiStatus.BAD_REQUEST_CODE)
      end
    end

    describe "updating inexistent model" do
      it "should return response code 404(not found)" do
        put :edit_issue_auto_category, :id => 0, :issue => @edited_issue, :category_name => @new_category_name, :format => :json
        response_has_status(ApiStatus.NOT_FOUND_CODE)
      end
    end
  end
end
