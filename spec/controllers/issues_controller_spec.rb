require 'spec_helper'

describe IssuesController do
  let(:category) { Category.to_api.last }
  let(:valid_issue_hash) {
    {
      name: 'foo',
      category: category,
      lat: Repara.map_center['lat'],
      lon: Repara.map_center['lon'],
      images: [{url: 'http://www.yahoo.com/asd.png'}],
      device_id: 'device_id'
    }
  }

  context 'content-type' do
    #context 'json' do
      #it 'returns all issues' do
        #header "Content-Type", "application/json"
        #get '/'
        #last_response.status.should == RequestCodes::SUCCESS
        #expect {
          #JSON.parse(last_response.body)['body']
        #}.to_not raise_error
      #end
    #end

    #context 'html' do
      #it 'returns a html with all the issues' do
        #header "Content-Type", "text/html"
        #get '/'
        #last_response.status.should == RequestCodes::SUCCESS
        #expect {
          #JSON.parse(last_response.body)
        #}.to raise_error
      #end
    #end
  end

  context 'find' do

    before(:all) do
      Issue.delete_all

      create(:issue)
      create(:issue, name: 'foo')
      create(:issue, name: 'foo2')
    end

    it 'returns all issues' do
      last_response = get :index, format: :json
      issues = JSON.parse(last_response.body)['body']
      issues.length.should == 3
    end

    it 'returns a specific issue' do
      issue = Issue.first
      last_response = get :show, id: issue.id.to_s, format: :json
      body = JSON.parse(last_response.body)['body']
      body['_id'].should == issue['_id'].to_s
    end

    it 'returns 404 when issue id is invalid' do
      last_response = get :show, id: 'invalid_id'
      last_response.status.should == 404
    end
  end

  context 'voting' do
    it 'upvotes' do
      issue = create(:issue)
      expect {
        last_response = post :vote, id: issue.id.to_s
        last_response.status.should == RequestCodes::SUCCESS
        issue.reload
      }.to change{issue.vote_counter}.by(1)
    end

    it 'downvotes' do
      issue = create(:issue)
      expect {
        last_response = delete :vote, id: issue.id.to_s
        last_response.status.should == RequestCodes::SUCCESS
        issue.reload
      }.to change{issue.vote_counter}.by(-1)
    end
  end

  context 'create' do
    it 'checks for required params' do
      last_response = post :create
      last_response.status.should == RequestCodes::BAD_REQUEST

      last_response = post :create, 'foo'
      last_response.status.should == RequestCodes::BAD_REQUEST

      last_response = post :create, 'foo', lat: 0
      last_response.status.should == RequestCodes::BAD_REQUEST

      last_response = post :create, name: 'foo', lon: 0
      last_response.status.should == RequestCodes::BAD_REQUEST

      last_response = post :create, name: 'foo', lon: 0, lon: 0
      last_response.status.should == RequestCodes::BAD_REQUEST

      last_response = post :create, valid_issue_hash
      last_response.status.should == RequestCodes::SUCCESS
    end

    it 'does not allow the user to specify a number for the vote_counter' do
      expect {
        hacking_vote_counter = valid_issue_hash
        hacking_vote_counter['vote_counter'] = 9001
        last_response = post :create, hacking_vote_counter
        JSON.parse(last_response.body)['body']['vote_counter'].should == 0
      }.to change{Issue.count}.by 1
    end

    it 'creates an issue' do
      expect {
        post :create, valid_issue_hash
      }.to change{Issue.count}.by 1

      a_bit_bigger = valid_issue_hash
      a_bit_bigger[:lat] += 1
      last_response = post :create, a_bit_bigger
      last_response.status.should == RequestCodes::SUCCESS
    end

    it 'does not create issues too far away from map center' do
      coords_too_far_away = valid_issue_hash
      coords_too_far_away[:lat] = 1
      coords_too_far_away[:lon] = 1
      last_response = post :create, coords_too_far_away
      last_response.status.should == RequestCodes::BAD_REQUEST
      JSON.parse(last_response.body)['code'].should ==  RequestCodes::TOO_FAR_FROM_MAP_CENTER
    end

    it 'sends the correct error code' do
      last_response = post :create, name: 'foo', lon: Repara.map_center_lon, lat: Repara.map_center_lat, category: category, device_id: 'device_id'
      last_response.status.should == RequestCodes::BAD_REQUEST
      JSON.parse(last_response.body)['code'].should == RequestCodes::REQUIRES_AT_LEAST_ONE_IMAGE
    end

    it 'requires category to be valid' do
      last_response = post :create, name: 'foo', category: 'foo', lat: 0, lon: 0, images: ['foo'], device_id: 'device_id'
      last_response.status.should == RequestCodes::BAD_REQUEST

      last_response = post :create, valid_issue_hash
      last_response.status.should == RequestCodes::SUCCESS
    end

    it 'returns nicely formatted json' do
      last_response = post :create, valid_issue_hash
      last_response.status.should == RequestCodes::SUCCESS
      json = JSON.parse(last_response.body)
      json['code'].should_not be_nil
    end

    it 'cries when an invalid image url is sent with the image' do
      issue_with_invalid_image_url = valid_issue_hash
      issue_with_invalid_image_url[:images][0] = {url: 'foo'}

      last_response = post :create, issue_with_invalid_image_url
      last_response.status.should == RequestCodes::BAD_REQUEST
      JSON.parse(last_response.body)['code'].should == RequestCodes::INVALID_IMAGE_URL
    end

    it 'cries when not given an image url' do
      issue_with_invalid_image_url = valid_issue_hash
      issue_with_invalid_image_url[:images][0] = {url: 'http://www.google.com/asd.txt'}

      last_response = post :create, issue_with_invalid_image_url
      last_response.status.should == RequestCodes::BAD_REQUEST
      JSON.parse(last_response.body)['code'].should == RequestCodes::INVALID_IMAGE_FORMAT
    end

    it 'cries when name is too long' do
      issue_with_invalid_image_url = valid_issue_hash
      issue_with_invalid_image_url[:name] = 'a' * (Repara.name_max_length + 2)

      last_response = post :create, issue_with_invalid_image_url
      last_response.status.should == RequestCodes::BAD_REQUEST
      JSON.parse(last_response.body)['code'].should == RequestCodes::STRING_TOO_BIG
    end
  end

  context 'update' do
    it 'updates an attribute' do
      issue = create(:issue)

      last_response = put :update, id: issue['_id'].to_s, name: 'bar'
      issue = Issue.find(issue['_id'].to_s)
      issue['name'].should == 'bar'

      issue['splat'].should be_nil
      issue['captures'].should be_nil

      last_response.status.should == RequestCodes::SUCCESS
    end

    it 'returns error when updating with invalid object id' do
      last_response = put :update, id: "/invalid_id", name: 'bar'
      last_response.status.should == RequestCodes::NOT_FOUND
    end

    it 'returns error when updating a field with an invalid value' do
      issue = create(:issue)
      last_response = put :update, id: issue['_id'].to_s, category: 'bar'
      last_response.status.should == RequestCodes::BAD_REQUEST
    end

    it 'checks that images hashes are valid' do
      issue = create(:issue)

      last_response = put :add_to_set, id: issue['_id'].to_s, 'images' => ['http://www.google.com/asd.png']
      last_response.status.should == RequestCodes::BAD_REQUEST
      JSON.parse(last_response.body)['code'].should == RequestCodes::INVALID_IMAGE_HASH_FORMAT
    end

    it 'adds an image url to images' do
      issue = create(:issue)

      issue['images'].count.should be 1
      last_response = put :add_to_set, id: issue['_id'].to_s, images: [{url: 'http://www.google.com/image2.png'}]

      issue = Issue.find(issue['_id'])
      issue.reload
      issue['images'].count.should be 2

      last_response.status.should == RequestCodes::SUCCESS
    end

    it 'adds a comment to comments' do
      issue = create(:issue)

      issue['comments'].count.should be 0
      last_response = put :add_to_set, id: issue['_id'].to_s, comments: ['comment']
      issue = Issue.find(issue['_id'])
      issue.reload
      issue['comments'].count.should be 1

      last_response.status.should == RequestCodes::SUCCESS
    end

    it 'does not add invalid comments' do
      issue = create(:issue)

      issue['comments'].count.should be 0
      last_response = put :add_to_set, id: issue['_id'], comments: [{asd: 'comment'}]
      issue = Issue.find(issue['_id'])
      issue.reload
      issue['comments'].count.should be 1
      issue.valid?.should be_false

      last_response.status.should == RequestCodes::BAD_REQUEST
      JSON.parse(last_response.body)['code'].should == RequestCodes::INVALID_COMMENT_FORMAT
    end
  end
end
