require 'spec_helper'

describe BannedIpsController, type: :controller do
  before :each do
    create :banned_ip
    create :banned_ip
  end

  it 'works' do
    get :index
    response.status.should eq RequestCodes::SUCCESS
  end

  it 'has the code and body params in the result' do
    get :index
    expect(json.key?('code')).to eq true
    expect(json.key?('body')).to eq true
  end

  it 'has status code 200' do
    get :index
    expect(json['code']).to eq RequestCodes::SUCCESS
  end

  it 'returns the two banned ips' do
    get :index
    expect(json['body'].class).to be Array
  end
end
 