require 'spec_helper'

describe Issue do
  let(:category) { create(:category).name }

  it 'uses the test db' do
    # repara-test can be found in config/mongoid.yml
    result = 'repara_server_test'.to_sym
    Mongoid.default_session.options[:database].to_sym.should be result
  end

  it 'uses factory girl' do
    build(:issue).should_not be_nil
  end

  it 'knows about the neighbourhood'

  it 'calculates the distance to the map center' do
    issue = build(:issue)
    dist = issue.distance_to_map_center
    dist.should be dist.to_f
  end

  context 'validation' do
    let(:issue) { build :issue }

    it 'knows if it is invalid before save' do
      i = Issue.new(name: 'foo', category: category, lat: 0, lon: 0)
      i.valid?.should be_false
    end

    it 'checks the validity of images hashes' do
      issue.images = ['not even a hash']
      issue.valid?.should be_false

      issue.images = [{ foo: 'not even a hash' }]
      issue.valid?.should be_false
    end

    it 'requires a valid category' do
      issue.category = 'asta_sigur_nu_e_categorie'
      issue.valid?.should be_false
    end

    it 'requires a valid neighbourhood'

    it 'only allows issues close to the map center' do
      issue.valid?.should be_true
      issue.lat = 80
      issue.valid?.should be_false
      result = :invalid_coordinates_too_far_from_map_center
      issue.errors.first.first.should eq result
    end

    it 'knows category will be downcased' do
      expect do
        issue.category = category.upcase
        issue.save
        issue.category.should == category
      end.to change { Issue.count }.by 1
    end

    it 'takes into account max length' do
      name_s = 'a' * (Repara.name_max_length + 2)
      build(:issue, name: name_s).valid?.should be_false

      address_s = 'a' * (Repara.address_max_length + 2)
      build(:issue, address: address_s).valid?.should be_false

      comment_s = 'a' * (Repara.comments_max_length + 2)
      build(:issue, comments: [comment_s]).valid?.should be_false
    end

    it 'checks for a valid comment format' do
      issue.add_params_to_set(
        'comments' => [{ foo: 'noice' }]
      )
      issue.valid?.should be_false
    end

    it 'requires a device id' do
      issue.device_id = nil
      issue.valid?.should be_false
    end

    it 'requires a status' do
      issue.status = nil
      issue.valid?.should be_false
    end

    it 'requires a valid status' do
      issue.status = Issue::VALID_STATUSES[1]
      issue.valid?.should be_true

      issue.status = 'not_a_valid_status'
      issue.valid?.should be_false
    end
  end

  it 'creates an issue' do
    expect do
      i = create(:issue)
      i.lat.should be Repara.map_center['lat']
      i.lon.should be Repara.map_center['lon']
      i.images.should_not be_empty
      i.images.first.key?(:thumb_url).should be_true
      i.comments.should be_empty
      i.errors.should be_empty
      i.created_at.to_s.should_not be_empty
      i.updated_at.to_s.should_not be_empty
    end.to change { Issue.count }.by 1
  end

  it 'updates images and comments through add_params_to_set' do
    issue = create(:issue)
    expect do
      img_array = [{ url: 'http://www.bew.one/pic.png' }]
      issue.add_params_to_set('images' => img_array, 'comments' => ['noice'])
      issue.reload
    end.to change { issue.images.count + issue.comments.count }.by 2
  end

  context 'voting' do
    it 'can upvote and downvote' do
      issue = create(:issue)

      issue.vote!(1)
      issue.reload
      issue.vote_counter.should be 1

      issue.vote!(-1)
      issue.reload
      issue.vote_counter.should be 0

      issue.vote!(1)
      issue.vote!(1)
      issue.reload
      issue.vote_counter.should be 2
    end
  end

  context 'search' do
    before :all do
      Issue.delete_all

      create(:issue, name: 'O Groapa Mare', comments: ['wow ce groapa'])
      create(:issue, name: 'vandalism', address: 'Strada Dumbravelor 21')
    end

    it 'takes into account the address' do
      Issue.full_text_search('dumbravelor').count.should be 1
    end

    it 'takes into account the name' do
      Issue.full_text_search('mare').count.should be 1
    end

    it 'takes into account the comments' do
      Issue.full_text_search('wow').count.should be 1
    end
  end
end
