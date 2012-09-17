require 'spec_helper'

def response_has_status(code)
  JSON.parse(response.body)["status"]["code"].should == code
end

describe CategoriesController do
  before :each do
    @category = FactoryGirl.create(:category)
    @category1 = FactoryGirl.create(:category)
    @category2 = FactoryGirl.create(:category)
    @category_attr = FactoryGirl.attributes_for(:category)
    @foo_category = { :foo => "bar" }
  end
  after :each do
    Category.delete_all
  end

  describe "GET #index" do
    describe "listing existing categories" do
      it "should list all categories" do
        get :index, :format => :json
        categories = JSON.parse(response.body)
        categories["response"]["categories"].to_json.should == [@category, @category1, @category2].to_json
      end

      it "status code should be 200" do
        get :index, :format => :json
        response_has_status(ApiStatus.OK_CODE)
      end
    end
  end

  describe "POST #create" do
    describe "with valid params" do
      it "should create category" do
        expect {
          post :create, :category => @category_attr, :format => :json
        }.to change(Category, :count).by(1)
      end

      it "should have response code 200" do
        post :create, :category => @category_attr, :format => :json
        response_has_status(ApiStatus.OK_CODE)
      end

      it "should match what we sent" do
        post :create, :category => @category_attr, :format => :json

        recieved_category = JSON.parse(response.body)["response"]["category"]
        sent_category = { "id" => Category.last.id, "name" => @category_attr[:name]  }

        sent_category["id"].should == recieved_category["id"]
        sent_category["name"].should == recieved_category["name"]
      end
    end

    describe "with good params, but no name param" do
      it "should return JSON with response code Bad Request(400)" do
        post :create, :category => @foo_category, :format => :json
        response_has_status(ApiStatus.BAD_REQUEST_CODE)
      end
    end

    describe "with no params" do
      it "should return JSON with response code Bad Request(400)" do
        post :create, :foo => @foo_category, :format => :json
        response_has_status(ApiStatus.BAD_REQUEST_CODE)
      end
    end
  end

  describe "PUT #update" do
    before :each do
      @edited_category_name = "problema"
      @edited_category = FactoryGirl.attributes_for(:category, :name => @edited_category_name )
    end

    describe "with valid params and existing model" do
      it "should modifiy the category" do
        put :update, :id => @category, :category => @edited_category, :format => :json
        @category.reload
        @category.name.should == @edited_category_name
      end

      it "should return respone code 200" do
        put :update, :id => @category, :category => @edited_category, :format => :json
        response_has_status(ApiStatus.OK_CODE)
      end
    end

    describe "with bad params on existing model" do
      it "should return response code 400(bad request)" do
        put :update, :id => @category, :category => @foo_category, :format => :json 
        response_has_status(ApiStatus.BAD_REQUEST_CODE)
      end
    end

    describe "updating inexistent model" do
      it "should return response code 404(not found)" do
        put :update, :id => 0, :category => @foo_category, :format => :json
        response_has_status(ApiStatus.NOT_FOUND_CODE)
      end
    end
  end

  describe "DELETE #destroy" do
    describe "deleting existing category" do
      it "should delete category" do
        expect {
          delete :destroy, :id => @category, :format => :json
        }.to change(Category, :count).by(-1)
      end

      it "should have JSON response code 200" do
        delete :destroy, :id => @category.id, :format => :json
        response_has_status(ApiStatus.OK_CODE)
      end
    end

    describe "deleting non-existing category" do
      it "should return JSON response status NOT FOUND" do
        delete :destroy, :id => 0, :format => :json
        response_has_status(ApiStatus.NOT_FOUND_CODE)
      end
    end
  end
end
