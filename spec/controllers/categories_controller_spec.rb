require 'spec_helper'

describe CategoriesController do
  describe "POST #create" do

    describe "with valid params" do
      it "should create category; =>JSON with response code 200" do
        category = FactoryGirl.build(:category)

        lambda {
          post :create, :category => { :name => category.name }, :format => :json
        }.should change(Category, :count).by(1)

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
end
