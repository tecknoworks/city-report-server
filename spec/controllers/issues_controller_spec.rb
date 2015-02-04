require 'spec_helper'

describe IssuesController, type: :controller do
  let(:category) { Category.to_api.last }
  let(:valid_issue_hash) do
    {
      name: 'foo',
      category: category,
      lat: Repara.map_center['lat'],
      lon: Repara.map_center['lon'],
      images: [{ url: 'http://www.yahoo.com/asd.png' }],
      device_id: 'device_id'
    }
  end

  context 'content-type' do
    # context 'json' do
    # it 'returns all issues' do
    # header "Content-Type", "application/json"
    # get '/'
    # last_response.status.should be RequestCodes::SUCCESS
    # expect {
    # JSON.parse(last_response.body)['body']
    # }.to_not raise_error
    # end
    # end

    # context 'html' do
    # it 'returns a html with all the issues' do
    # header "Content-Type", "text/html"
    # get '/'
    # last_response.status.should be RequestCodes::SUCCESS
    # expect {
    # JSON.parse(last_response.body)
    # }.to raise_error
    # end
    # end
  end

  context 'find' do

    before(:all) do
      Issue.delete_all

      create(:issue)
      create(:issue, name: 'foo')
      create(:issue, name: 'foo2')
    end

    it 'returns all issues' do
      get :index, format: :json
      issues = json['body']
      issues.length.should be 3
    end

    it 'returns a specific issue' do
      issue = Issue.first
      get :show, id: issue.id.to_s, format: :json
      json['body']['_id'].should == issue['_id'].to_s
    end

    it 'returns 404 when issue id is invalid' do
      get :show, id: 'invalid_id'
      response.status.should be 404
    end
  end

  context 'voting' do
    let(:issue) { create :issue }

    it 'upvotes' do
      issue
      expect do
        post :vote, id: issue.id.to_s
        response.status.should be RequestCodes::SUCCESS
        issue.reload
      end.to change { issue.vote_counter }.by(1)
    end

    it 'downvotes' do
      issue
      expect do
        delete :vote, id: issue.id.to_s
        response.status.should be RequestCodes::SUCCESS
        issue.reload
      end.to change { issue.vote_counter }.by(-1)
    end
  end

  context 'create' do
    it 'checks for required params' do
      post :create
      response.status.should be RequestCodes::BAD_REQUEST

      post :create, 'foo'
      response.status.should be RequestCodes::BAD_REQUEST

      post :create, 'foo', lat: 0
      response.status.should be RequestCodes::BAD_REQUEST

      post :create, name: 'foo', lon: 0
      response.status.should be RequestCodes::BAD_REQUEST

      post :create, name: 'foo', lon: 0, lon: 0
      response.status.should be RequestCodes::BAD_REQUEST

      post :create, valid_issue_hash
      response.status.should be RequestCodes::SUCCESS
    end

    it 'does not allow the user to specify a number for the vote_counter' do
      expect do
        hacking_vote_counter = valid_issue_hash
        hacking_vote_counter['vote_counter'] = 9001
        post :create, hacking_vote_counter
        json['body']['vote_counter'].should be 0
      end.to change { Issue.count }.by 1
    end

    it 'creates an issue' do
      expect do
        post :create, valid_issue_hash
      end.to change { Issue.count }.by 1

      a_bit_bigger = valid_issue_hash
      a_bit_bigger[:lat] += 1
      post :create, a_bit_bigger
      response.status.should be RequestCodes::SUCCESS
    end

    it 'does not create issues too far away from map center' do
      coords_too_far_away = valid_issue_hash
      coords_too_far_away[:lat] = 1
      coords_too_far_away[:lon] = 1
      post :create, coords_too_far_away
      response.status.should be RequestCodes::BAD_REQUEST
      json['code'].should be RequestCodes::TOO_FAR_FROM_MAP_CENTER
    end

    it 'sends the correct error code' do
      post :create, name: 'foo', lon: Repara.map_center_lon,
                    lat: Repara.map_center_lat, category: category,
                    device_id: 'device_id'
      response.status.should be RequestCodes::BAD_REQUEST
      json['code'].should be RequestCodes::REQUIRES_AT_LEAST_ONE_IMAGE
    end

    it 'requires category to be valid' do
      post :create, name: 'foo', category: 'foo', lat: 0, lon: 0,
                    images: ['foo'], device_id: 'device_id'
      response.status.should be RequestCodes::BAD_REQUEST

      post :create, valid_issue_hash
      response.status.should be RequestCodes::SUCCESS
    end

    it 'returns nicely formatted json' do
      post :create, valid_issue_hash
      response.status.should be RequestCodes::SUCCESS
      json['code'].should_not be_nil
    end

    it 'cries when an invalid image url is sent with the image' do
      issue_with_invalid_image_url = valid_issue_hash
      issue_with_invalid_image_url[:images][0] = { url: 'foo' }

      post :create, issue_with_invalid_image_url
      response.status.should be RequestCodes::BAD_REQUEST
      json['code'].should be RequestCodes::INVALID_IMAGE_URL
    end

    it 'cries when not given an image url' do
      issue_with_invalid_image_url = valid_issue_hash
      issue_with_invalid_image_url[:images][0] = {
        url: 'http://www.google.com/asd.txt'
      }

      post :create, issue_with_invalid_image_url
      response.status.should be RequestCodes::BAD_REQUEST
      json['code'].should be RequestCodes::INVALID_IMAGE_FORMAT
    end

    it 'cries when name is too long' do
      issue_with_invalid_image_url = valid_issue_hash
      issue_with_invalid_image_url[:name] = 'a' * (Repara.name_max_length + 2)

      post :create, issue_with_invalid_image_url
      response.status.should be RequestCodes::BAD_REQUEST
      json['code'].should be RequestCodes::STRING_TOO_BIG
    end
  end

  context 'update' do
    it 'updates an attribute' do
      issue = create(:issue)

      put :update, id: issue['_id'].to_s, name: 'bar'
      response.status.should be RequestCodes::SUCCESS

      issue = Issue.find(issue['_id'].to_s)
      issue['name'].should eq 'bar'

      issue['splat'].should be_nil
      issue['captures'].should be_nil
    end

    it 'returns error when updating with invalid object id' do
      put :update, id: '/invalid_id', name: 'bar'
      response.status.should be RequestCodes::NOT_FOUND
    end

    it 'returns error when updating a field with an invalid value' do
      issue = create(:issue)

      put :update, id: issue['_id'].to_s, category: 'bar'
      response.status.should be RequestCodes::BAD_REQUEST
    end

    it 'checks that images hashes are valid' do
      issue = create(:issue)

      put :add_to_set, id: issue['_id'].to_s,
                       images: ['http://www.google.com/asd.png']
      response.status.should be RequestCodes::BAD_REQUEST
      json['code'].should be RequestCodes::INVALID_IMAGE_HASH_FORMAT
    end

    it 'adds an image url to images' do
      issue = create(:issue)

      issue['images'].count.should be 1
      put :add_to_set, id: issue['_id'].to_s,
                       images: [{ url: 'http://www.google.com/image2.png' }]
      response.status.should be RequestCodes::SUCCESS

      issue = Issue.find(issue['_id'])
      issue.reload
      issue['images'].count.should be 2
    end

    it 'adds a comment to comments' do
      issue = create(:issue)

      issue['comments'].count.should be 0
      put :add_to_set, id: issue['_id'].to_s, comments: ['comment']
      response.status.should be RequestCodes::SUCCESS

      issue = Issue.find(issue['_id'])
      issue.reload
      issue['comments'].count.should be 1
    end

    it 'does not add invalid comments' do
      issue = create(:issue)

      issue['comments'].count.should be 0
      put :add_to_set, id: issue['_id'], comments: [{ asd: 'comment' }]
      response.status.should be RequestCodes::BAD_REQUEST
      json['code'].should be RequestCodes::INVALID_COMMENT_FORMAT

      issue = Issue.find(issue['_id'])
      issue.reload
      issue['comments'].count.should be 1
      issue.valid?.should be_false
    end
  end

  context 'BannedIp' do
    it 'can not create issue'
    it 'can not update issue'
    it 'can not delete issue'
  end
end
