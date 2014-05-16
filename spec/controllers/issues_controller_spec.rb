require 'spec_helper'

describe IssuesController do
  let(:category) { Repara.categories.last }
  let(:valid_issue_hash) { {name: 'foo', category: category, lat: 0, lon: 0, images: [{url: 'http://www.yahoo.com/asd.png'}]} }

  context 'find' do
    before(:all) do
      Issue.delete_all

      create(:issue)
      create(:issue, name: 'foo')
      create(:issue, name: 'foo2')
    end

    it 'returns all issues' do
      get '/'
      issues = JSON.parse(last_response.body)['body']
      issues.length.should == 3
    end

    it 'returns a specific issue' do
      issue = Issue.first
      get "/#{issue.id}"
      JSON.parse(last_response.body)['body']['_id'].should == issue['_id'].to_s
    end

    it 'returns 404 when issue id is invalid' do
      get '/invalid_id'
      last_response.status.should == 404
    end
  end

  context 'voting' do
    it 'upvotes' do
      issue = create(:issue)
      expect {
        post "/#{issue.id.to_s}/vote"
        last_response.status.should == RequestCodes::SUCCESS
        issue.reload
      }.to change{issue.vote_counter}.by(1)
    end

    it 'downvotes' do
      issue = create(:issue)
      expect {
        delete "/#{issue.id.to_s}/vote"
        last_response.status.should == RequestCodes::SUCCESS
        issue.reload
      }.to change{issue.vote_counter}.by(-1)
    end
  end

  context 'create' do
    it 'checks for required params' do
      post '/'
      last_response.status.should == RequestCodes::BAD_REQUEST

      post '/', name: 'foo'
      last_response.status.should == RequestCodes::BAD_REQUEST

      post '/', name: 'foo', lat: 0
      last_response.status.should == RequestCodes::BAD_REQUEST

      post '/', name: 'foo', lon: 0
      last_response.status.should == RequestCodes::BAD_REQUEST

      post '/', name: 'foo', lon: 0, lon: 0
      last_response.status.should == RequestCodes::BAD_REQUEST

      post '/', valid_issue_hash
      last_response.status.should == RequestCodes::SUCCESS
    end

    it 'does not allow the user to specify a number for the vote_counter' do
      expect {
        hacking_vote_counter = valid_issue_hash
        hacking_vote_counter['vote_counter'] = 9001
        post '/', hacking_vote_counter
        JSON.parse(last_response.body)['body']['vote_counter'].should == 0
      }.to change{Issue.count}.by 1
    end

    it 'creates an issue' do
      expect {
        post '/', valid_issue_hash
      }.to change{Issue.count}.by 1
    end

    it 'sends the correct error code' do
      post '/', name: 'foo', lon: 0, lat: 0, category: category
      last_response.status.should == RequestCodes::BAD_REQUEST
      JSON.parse(last_response.body)['code'].should == RequestCodes::REQUIRES_AT_LEAST_ONE_IMAGE
    end

    it 'requires category to be valid' do
      post '/', name: 'foo', category: 'foo', lat: 0, lon: 0, images: ['foo']
      last_response.status.should == RequestCodes::BAD_REQUEST

      post '/', valid_issue_hash
      last_response.status.should == RequestCodes::SUCCESS
    end

    it 'returns nicely formatted json' do
      post '/', valid_issue_hash
      last_response.status.should == RequestCodes::SUCCESS
      json = JSON.parse(last_response.body)
      json['code'].should_not be_nil
    end

    it 'cries when an invalid image url is sent with the image' do
      issue_with_invalid_image_url = valid_issue_hash
      issue_with_invalid_image_url[:images][0] = {url: 'foo'}

      post '/', issue_with_invalid_image_url
      last_response.status.should == RequestCodes::BAD_REQUEST
      JSON.parse(last_response.body)['code'].should == RequestCodes::INVALID_IMAGE_URL
    end

    it 'cries when not given an image url' do
      issue_with_invalid_image_url = valid_issue_hash
      issue_with_invalid_image_url[:images][0] = {url: 'http://www.google.com/asd.txt'}

      post '/', issue_with_invalid_image_url
      last_response.status.should == RequestCodes::BAD_REQUEST
      JSON.parse(last_response.body)['code'].should == RequestCodes::INVALID_IMAGE_FORMAT
    end

    it 'cries when name is too long' do
      issue_with_invalid_image_url = valid_issue_hash
      issue_with_invalid_image_url[:name] = 'a' * (Repara.name_max_length + 2)

      post '/', issue_with_invalid_image_url
      last_response.status.should == RequestCodes::BAD_REQUEST
      JSON.parse(last_response.body)['code'].should == RequestCodes::STRING_TOO_BIG
    end
  end

  context 'update' do
    it 'updates an attribute' do
      issue = create(:issue)

      put "/#{issue['_id']}", name: 'bar'
      issue = Issue.find(issue['_id'])
      issue['name'].should == 'bar'

      issue['splat'].should be_nil
      issue['captures'].should be_nil

      last_response.status.should == RequestCodes::SUCCESS
    end

    it 'returns error when updating with invalid object id' do
      put "/invalid_id", name: 'bar'
      last_response.status.should == RequestCodes::NOT_FOUND
    end

    it 'returns error when updating a field with an invalid value' do
      issue = create(:issue)
      put "/#{issue['_id']}", category: 'bar'
      last_response.status.should == RequestCodes::BAD_REQUEST
    end

    it 'checks that images hashes are valid' do
      issue = create(:issue)

      put "/#{issue['_id']}/add_to_set", 'images' => ['http://www.google.com/asd.png']
      last_response.status.should == RequestCodes::BAD_REQUEST
      JSON.parse(last_response.body)['code'].should == RequestCodes::INVALID_IMAGE_HASH_FORMAT
    end

    it 'adds an image url to images' do
      issue = create(:issue)

      issue['images'].count.should be 1
      put "/#{issue['_id']}/add_to_set", images: [{url: 'http://www.google.com/image2.png'}]

      issue = Issue.find(issue['_id'])
      issue.reload
      issue['images'].count.should be 2

      last_response.status.should == RequestCodes::SUCCESS
    end

    it 'adds a comment to comments' do
      issue = create(:issue)

      issue['comments'].count.should be 0
      put "/#{issue['_id']}/add_to_set", comments: ['comment']
      issue = Issue.find(issue['_id'])
      issue.reload
      issue['comments'].count.should be 1

      last_response.status.should == RequestCodes::SUCCESS
    end

    it 'does not add invalid comments' do
      issue = create(:issue)

      issue['comments'].count.should be 0
      put "/#{issue['_id']}/add_to_set", comments: [{asd: 'comment'}]
      issue = Issue.find(issue['_id'])
      issue.reload
      issue['comments'].count.should be 1
      issue.valid?.should be_false

      last_response.status.should == RequestCodes::BAD_REQUEST
      JSON.parse(last_response.body)['code'].should == RequestCodes::INVALID_COMMENT_FORMAT
    end
  end
end
