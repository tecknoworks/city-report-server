require 'spec_helper'

describe CategoriesController do
  describe "POST #create" do

    describe "with valid params" do
      it "should create category and return JSON" do
        category = FactoryGirl.build(:category)

        lambda {
          post :create, :category => { :name => category.name }, :format => :json
        }.should change(Category, :count).by(1)

        recieved_category = JSON.parse(response.body)
        sent_category = { "id" => Category.last.id, "name" => category.name  }

        sent_category["id"].should == recieved_category["id"]
        sent_category["name"].should == recieved_category["name"]
      end
    end

    describe "with good params, but no name param" do
      it "should return JSON with error code" do
        post :create, :category => { :foo => "baz" }, :format => :json
        JSON.parse(response.body).should == { "error" => { "code" => "1"} }
      end
    end

    describe "with no params" do
      it "should return JSON with error code" do
        post :create, :foo => { :bar => "baz" }, :format => :json
        JSON.parse(response.body).should == { "error" => { "code" => "1"} }
      end
    end

  end
end
