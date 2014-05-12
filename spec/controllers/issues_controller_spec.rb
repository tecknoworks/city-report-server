require 'spec_helper'

describe IssuesController do
  let(:category) { Repara.categories.last }
  let(:valid_issue_hash) { {name: 'foo', category: category, lat: 0, lon: 0, images: ['http://www.yahoo.com/asd.png']} }

  context 'find' do
    it 'returns all issues' do
      #post '/', valid_issue_hash
      #get '/'
      #issue = JSON.parse(last_response.body)['body'].first
      #p issue
    end
  end

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

      post '/', name: 'foo', lon: 0, lon: 0
      last_response.status.should == 400

      post '/', valid_issue_hash
      last_response.status.should == 200
    end

    it 'creates an issue' do
      expect {
        post '/', valid_issue_hash
      }.to change{Issue.count}.by 1
    end

    it 'sends the correct error code' do
      post '/', name: 'foo', lon: 0, lat: 0, category: category
      last_response.status.should == 400
      JSON.parse(last_response.body)['code'].should == 400004
    end

    it 'requires category to be valid' do
      post '/', name: 'foo', category: 'foo', lat: 0, lon: 0, images: ['foo']
      last_response.status.should == 400

      post '/', valid_issue_hash
      last_response.status.should == 200
    end

    it 'returns nicely formatted json' do
      post '/', valid_issue_hash
      last_response.status.should == 200
      json = JSON.parse(last_response.body)
      json['code'].should_not be_nil
    end

    it 'cries when an invalid image url is sent with the image' do
      issue_with_invalid_image_url = valid_issue_hash
      issue_with_invalid_image_url[:images][0] = 'foo'

      post '/', issue_with_invalid_image_url
      last_response.status.should == 400
      JSON.parse(last_response.body)['code'].should == RequestCodes::INVALID_IMAGE_URL
    end

    it 'cries when not given an image url' do
      issue_with_invalid_image_url = valid_issue_hash
      issue_with_invalid_image_url[:images][0] = 'http://www.google.com/asd.txt'

      post '/', issue_with_invalid_image_url
      last_response.status.should == 400
      JSON.parse(last_response.body)['code'].should == RequestCodes::INVALID_IMAGE_FORMAT
    end
  end

  context 'update' do
    it 'updates an attribute' do
      post '/', valid_issue_hash
      issue = JSON.parse(last_response.body)['body']
      issue['name'].should == 'foo'

      put "/#{issue['_id']}", name: 'bar'
      issue = Issue.find(issue['_id'])
      issue['name'].should == 'bar'

      issue['splat'].should be_nil
      issue['captures'].should be_nil
    end

    it 'returns error when updating with invalid object id' do
      post '/', name: 'foo', category: category
      put "/invalid_id", name: 'bar'
      last_response.status.should == 404
    end

    it 'returns error when updating a field with an invalid value' do
      post '/', valid_issue_hash
      issue = JSON.parse(last_response.body)['body']
      put "/#{issue['_id']}", category: 'bar'
      last_response.status.should == 400
    end

    it 'adds an image url to images' do
      post '/', valid_issue_hash
      issue = JSON.parse(last_response.body)['body']

      issue['images'].count.should be 1
      put "/#{issue['_id']}/add_to_set", 'images' => ['http://www.google.com']

      issue = Issue.find(issue['_id'])
      issue['images'].count.should be 2
      issue['images'].should_not be_empty
    end
  end
end
