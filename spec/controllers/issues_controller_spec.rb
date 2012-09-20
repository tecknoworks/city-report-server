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

  describe "PUT #update" do
    before :each do
      @issue_title = "Gunoi in fata statiei de autobuz"
      @issue_latitude = 45.323
      @issue_longitude = 43.3232
      @new_category = FactoryGirl.create(:category, :name => "Gunoi")
      @edited_issue = FactoryGirl.attributes_for(:issue, :title => @issue_title, 
                                                         :latitude => @issue_latitude,
                                                         :longitude => @issue_longitude,
                                                         :category_id => @new_category.id)
    end

    describe "with valid params and existing model" do
      it "should modifiy the issue" do
        put :update, :id => @issue, :issue => @edited_issue , :format => :json
        @issue.reload
        @issue.title.should == @issue_title
        @issue.latitude.should == @issue_latitude
        @issue.longitude.should == @issue_longitude
        @issue.category_id.should == @new_category.id 
      end

      it "should return respone code 200" do
        put :update, :id => @issue, :issue => @edited_issue, :format => :json
        response_has_status(ApiStatus.OK_CODE)
      end
    end

    describe "with bad params on existing model" do
      it "should return response code 400(bad request)" do
        put :update, :id => @issue, :issue => @foo_issue, :format => :json 
        response_has_status(ApiStatus.BAD_REQUEST_CODE)
      end
    end

    describe "updating inexistent model" do
      it "should return response code 404(not found)" do
        put :update, :id => 0, :issue => @foo_issue, :format => :json
        response_has_status(ApiStatus.NOT_FOUND_CODE)
      end
    end
  end

  describe "DELETE #destroy" do
    describe "deleting existing issue" do
      it "should delete issue" do
        expect {
          delete :destroy, :id => @issue, :format => :json
        }.to change(Issue, :count).by(-1)
      end

      it "should have JSON response code 200" do
        delete :destroy, :id => @issue, :format => :json
        response_has_status(ApiStatus.OK_CODE)
      end
    end

    describe "deleting non-existing issue" do
      it "should return JSON response status NOT FOUND" do
        delete :destroy, :id => 0, :format => :json
        response_has_status(ApiStatus.NOT_FOUND_CODE)
      end
    end
  end
end
