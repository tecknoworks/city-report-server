require 'spec_helper'

describe IssuesController do
  let(:category) { Repara.categories.last }

  context 'create' do
    it 'checks for required params' do
      post '/'
      last_response.status.should == 400

      post '/', name: 'foo'
      last_response.status.should == 400

      post '/', name: 'foo', lat: 0
      last_response.status.should == 400

      post '/', name: 'foo', lon: 0
      last_response.status.should == 400

      post '/', name: 'foo', category: category, lat: 0, lon: 0
      last_response.status.should == 200
    end

    it 'requires category to be valid' do
      post '/', name: 'foo', category: 'foo', lat: 0, lon: 0
      last_response.status.should == 400

      post '/', name: 'foo', category: category, lat: 0, lon: 0
      last_response.status.should == 200
    end
  end

  context 'update' do
    it 'updates an attribute' do
      post '/', name: 'foo', category: category, lat: 0, lon: 0
      issue = JSON.parse(last_response.body)
      issue['name'].should == 'foo'

      put "/#{issue['_id']}", name: 'bar'
      issue = Issue.find(issue['_id'])
      issue['name'].should == 'bar'

      issue['splat'].should be_nil
      issue['captures'].should be_nil
    end

    it 'returns error when updating with invalid object id' do
      post '/', name: 'foo', category: category
      issue = JSON.parse(last_response.body)

      put "/invalid_id", name: 'bar'
      last_response.status.should == 404
    end

    it 'returns error when updating a field with an invalid value' do
      post '/', name: 'foo', category: category, lat: 0, lon: 0
      issue = JSON.parse(last_response.body)
      put "/#{issue['_id']}", category: 'bar'
      last_response.status.should == 400
    end

    it 'adds an image url to images' do
      post '/', name: 'foo', category: category, lat: 0, lon: 0
      issue = JSON.parse(last_response.body)

      issue['images'].should be_empty
      put "/#{issue['_id']}/add_to_set", 'images' => ['http://www.google.com']

      issue = Issue.find(issue['_id'])
      issue['images'].should_not be_empty
    end
  end
end
