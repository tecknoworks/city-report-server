require 'spec_helper'

describe BannedIpsController, type: :controller do
  let(:banned_ip1) { create :banned_ip }
  let(:banned_ip2) { create :banned_ip }

  before :each do
    banned_ip1
    banned_ip2
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

  it 'returns a specific banned_ip' do
    banned_ip1
    get :show, id: banned_ip1.id.to_s
    expect(json['id']).to eq banned_ip1.id.to_s
  end

  it 'creates a banned ip' do
    expect {
      post :create, banned_ip: { address: '192.168.0.0' }
      expect(response.status).to eq RequestCodes::SUCCESS
    }.to change { BannedIp.count }.by 1
  end

  it 'updates the address of a banned ip' do
    addr = '192.168.0.12'
    banned_ip1

    patch :update, id: banned_ip1.id.to_s, banned_ip: { address: addr }

    expect(json['address']).to eq addr
    banned_ip1.reload
    expect(banned_ip1.address).to eq addr
  end

  it 'deletes a banned ip' do
    banned_ip1

    expect {
      delete :destroy, id: banned_ip1.id.to_s
    }.to change { BannedIp.count }.by(-1)
  end
end
