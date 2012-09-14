require 'spec_helper'

describe CategoriesController do
  describe "GET #index" do

    describe "listing existing categories" do
      it "should list all categories" do
        category1 = FactoryGirl.create(:category)
        category2 = FactoryGirl.create(:category)
        get :index, :format => :json
        categories = JSON.parse(response.body)
        categories["response"]["categories"].to_json.should == [category1, category2].to_json
      end

      it "status code should be 200" do
        get :index, :format => :json
        JSON.parse(response.body)["status"]["code"].should == ApiStatus.OK_CODE
      end
    end
  end

  describe "POST #create" do

    describe "with valid params" do
      it "should create category; =>JSON with response code 200" do
        category = FactoryGirl.create(:category)
        expect {
          post :create, :category => FactoryGirl.attributes_for(:category), :format => :json
        }.to change(Category, :count).by(1)

        JSON.parse(response.body)["status"]["code"].should == ApiStatus.OK_CODE

        recieved_category = JSON.parse(response.body)["response"]["category"]
        sent_category = { "id" => Category.last.id, "name" => category.name  }

        sent_category["id"].should == recieved_category["id"]
        sent_category["name"].should == recieved_category["name"]
      end
    end

    describe "with good params, but no name param" do
      it "should return JSON with response code Bad Request(400)" do
        post :create, :category => { :foo => "baz" }, :format => :json
        JSON.parse(response.body)["status"]["code"].should == ApiStatus.BAD_REQUEST_CODE
      end
    end

    describe "with no params" do
      it "should return JSON with response code Bad Request(400)" do
        post :create, :foo => { :bar => "baz" }, :format => :json
        JSON.parse(response.body)["status"]["code"].should == ApiStatus.BAD_REQUEST_CODE
      end
    end
  end


  describe "PUT #update" do
    describe "with valid params and existing model" do
      it "should modifiy the category" do
        existing_category = FactoryGirl.create(:category)
        put :update, :id => existing_category, :category => FactoryGirl.attributes_for(:category, :name => "Problema"), :format => :json
        existing_category.reload
        existing_category.name.should == "Problema"
      end
      it "should return respone code 200" do
        existing_category = FactoryGirl.create(:category)
        put :update, :id => existing_category, :category => FactoryGirl.attributes_for(:category, :name => "Problema"), :format => :json
        JSON.parse(response.body)["status"]["code"].should == ApiStatus.OK_CODE
      end
    end
    describe "with bad params on existing model" do
      it "should return response code 400(bad request)" do
        existing_category = FactoryGirl.create(:category)
        put :update, :id => existing_category, :category => { :foo => "bar" }, :format => :json 
        JSON.parse(response.body)["status"]["code"].should == ApiStatus.BAD_REQUEST_CODE
      end
    end
    describe "updating inexistent model" do
      it "should return response code 404(not found)" do
        put :update, :id => 0, :category => { :foo => "bar" }, :format => :json
        JSON.parse(response.body)["status"]["code"].should == ApiStatus.NOT_FOUND_CODE
      end
    end
  end

  describe "DELETE #destroy" do

    describe "deleting existing category" do
      it "should delete category" do
        category = FactoryGirl.create(:category)

        expect {
          delete :destroy, :id => category, :format => :json
        }.to change(Category, :count).by(-1)
      end

      it "should have JSON response code 200" do
        category = FactoryGirl.create(:category)
        delete :destroy, :id => category.id, :format => :json
        JSON.parse(response.body)["status"]["code"].should == ApiStatus.OK_CODE
      end
    end

    describe "deleting non-existing category" do
      it "should return JSON response status NOT FOUND" do
        delete :destroy, :id => 0, :format => :json
        JSON.parse(response.body)["status"]["code"].should == ApiStatus.NOT_FOUND_CODE
      end
    end

  end
end
