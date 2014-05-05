require 'spec_helper'

describe IssuesController do
  let(:category) { Repara.categories.last }

  context 'create' do
    it 'checks for required params' do
      post '/'
      last_response.status.should == 400

      post '/', name: 'foo'
      last_response.status.should == 400

      post '/', name: 'foo', category: category
      last_response.status.should == 200
    end

    it 'requires category to be valid' do
      post '/', name: 'foo', category: 'foo'
      last_response.status.should == 400

      post '/', name: 'foo', category: category
      last_response.status.should == 200
    end
  end

  context 'update' do
    it 'updates an attribute' do
      post '/', name: 'foo', category: category
      issue = JSON.parse(last_response.body)
      issue['name'].should == 'foo'

      put "/#{issue['_id']}", name: 'bar'
      issue2 = Issue.find(issue['_id'])
      issue2['name'].should == 'bar'
      issue2['splat'].should be_nil
      issue2['captures'].should be_nil
    end

    it 'adds an image url to images' do
      post '/', name: 'foo', category: category
      issue = JSON.parse(last_response.body)

      issue['images'].should be_empty
      put "/#{issue['_id']}/add_to_set", :images => ['http://www.google.com']
    end
  end
end
