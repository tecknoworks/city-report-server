require 'spec_helper'

describe Issue do
  let(:category) { Repara.categories.last }

  it 'should use test db' do
    # repara-test can be found in config/mongoid.yml
    Mongoid.default_session.options[:database].should == 'repara-test'
  end

  it 'uses factory girl' do
    build(:issue).should_not be_nil
  end

  it 'knows if it is invalid before save' do
    Issue.new(name: 'foo', category: category, lat: 0, lon: 0).valid?.should be_false
  end

  it 'checks the validity of images hashes' do
    issue = build(:issue, images: ['not even a hash'])
    issue.valid?.should be_false

    issue = build(:issue, images: [{foo: 'not even a hash'}])
    issue.valid?.should be_false
  end

  it 'should create an issue' do
    expect {
      i = create(:issue)
      i.lat.should == 1
      i.lon.should == 2
      i.images.should_not be_empty
      i.images.first.has_key?(:thumb_url).should be_true
      i.errors.should be_empty
    }.to change{ Issue.count }.by 1
  end

  it 'requires a valid category' do
    build(:issue, category: 'asta_sigur_nu_e_categorie').valid?.should be_false
  end

  it 'knows category will be downcased' do
    expect {
      issue = create(:issue, category: 'ALTELE')
      issue.category.should == 'altele'
    }.to change{ Issue.count }.by 1
  end

  it 'votes up and down' do
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

  it 'takes into account max length' do
    build(:issue, name: 'a' * (Repara.name_max_length + 2)).valid?.should be_false
    build(:issue, address: 'a' * (Repara.address_max_length + 2)).valid?.should be_false
    build(:issue, comments: ['a' * (Repara.comments_max_length + 2)]).valid?.should be_false
  end

  it 'should add_params_to_set' do
    issue = create(:issue)
    expect {
      issue.add_params_to_set( {'images' => [{url: 'http://www.bew.one/pic.png'}], 'comments' => ['noice'] })
      issue.reload
    }.to change {issue.images.count + issue.comments.count}.by 2
  end

  it 'checks for a valid comment format' do
    issue = create(:issue)
    issue.add_params_to_set({
      'comments' => [{foo: 'noice'}]
    })
    issue.valid?.should be_false
  end

  context 'search' do
    before :all do
      Issue.delete_all

      create(:issue, name: 'O Groapa Mare')
      create(:issue, name: 'vandalism', address: 'Strada Dumbravelor 21')
    end

    it 'should' do
      Issue.full_text_search("dumb").each do |foo|
        # p foo
      end
    end
  end
end
