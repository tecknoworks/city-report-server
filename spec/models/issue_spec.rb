require 'spec_helper'

describe Issue do
  let(:category) { Repara.categories.last }

  it 'uses the test db' do
    # repara-test can be found in config/mongoid.yml
    Mongoid.default_session.options[:database].to_sym.should == 'repara_server_test'.to_sym
  end

  it 'uses factory girl' do
    build(:issue).should_not be_nil
  end

  it 'knows about the neighbourhood'

  it 'calculates the distance to the map center' do
    issue = build(:issue)
    dist = issue.distance_to_map_center
    dist.should == dist.to_f
  end

  context 'validation' do
    it 'knows if it is invalid before save' do
      Issue.new(name: 'foo', category: category, lat: 0, lon: 0).valid?.should be_false
    end

    it 'checks the validity of images hashes' do
      issue = build(:issue, images: ['not even a hash'])
      issue.valid?.should be_false

      issue = build(:issue, images: [{foo: 'not even a hash'}])
      issue.valid?.should be_false
    end

    it 'requires a valid category' do
      build(:issue, category: 'asta_sigur_nu_e_categorie').valid?.should be_false
    end

    it 'requires a valid neighbourhood'

    it 'only allows issues close to the map center' do
      issue =  build(:issue)
      issue.valid?.should be_true
      issue.lat = 80
      issue.valid?.should be_false
      issue.errors.first.first.should eq :invalid_coordinates_too_far_from_map_center
    end

    it 'knows category will be downcased' do
      expect {
        issue = create(:issue, category: 'ALTELE')
        issue.category.should == 'altele'
      }.to change{ Issue.count }.by 1
    end

    it 'takes into account max length' do
      build(:issue, name: 'a' * (Repara.name_max_length + 2)).valid?.should be_false
      build(:issue, address: 'a' * (Repara.address_max_length + 2)).valid?.should be_false
      build(:issue, comments: ['a' * (Repara.comments_max_length + 2)]).valid?.should be_false
    end

    it 'checks for a valid comment format' do
      issue = create(:issue)
      issue.add_params_to_set({
        'comments' => [{foo: 'noice'}]
      })
      issue.valid?.should be_false
    end
  end

  it 'creates an issue' do
    expect {
      i = create(:issue)
      i.lat.should == Repara.map_center['lat']
      i.lon.should == Repara.map_center['lon']
      i.images.should_not be_empty
      i.images.first.has_key?(:thumb_url).should be_true
      i.comments.should be_empty
      i.errors.should be_empty
      i.created_at.to_s.should_not be_empty
      i.updated_at.to_s.should_not be_empty
    }.to change{ Issue.count }.by 1
  end

  it 'updates images and comments through add_params_to_set' do
    issue = create(:issue)
    expect {
      issue.add_params_to_set( {'images' => [{url: 'http://www.bew.one/pic.png'}], 'comments' => ['noice'] })
      issue.reload
    }.to change {issue.images.count + issue.comments.count}.by 2
  end

  context 'voting' do
    it 'can upvote and downvote' do
      issue = create(:issue)

      issue.vote!(1)
      issue.reload
      issue.vote_counter.should == 1

      issue.vote!(-1)
      issue.reload
      issue.vote_counter.should == 0

      issue.vote!(1)
      issue.vote!(1)
      issue.reload
      issue.vote_counter.should == 2
    end
  end

  context 'search' do
    before :all do
      Issue.delete_all

      create(:issue, name: 'O Groapa Mare', comments: ['wow ce groapa'])
      create(:issue, name: 'vandalism', address: 'Strada Dumbravelor 21')
    end

    it 'takes into account the category' do
      Issue.full_text_search("altele").count.should == 2
    end

    it 'takes into account the address' do
      Issue.full_text_search("dumbravelor").count.should == 1
    end

    it 'takes into account the name' do
      Issue.full_text_search("mare").count.should == 1
    end

    it 'takes into account the comments' do
      Issue.full_text_search("wow").count.should == 1
    end
  end
end
