require 'spec_helper'

describe BannedIpsController, type: :controller do
  let(:banned_ip1) { create :banned_ip }
  let(:banned_ip2) { create :banned_ip2 }

  before :each do
    BannedIp.delete_all
    banned_ip1
    banned_ip2
  end

  describe '#index' do

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
      expect(json['body'].size).to be > 0
    end
  end

  describe '#show' do

    it 'returns a specific banned_ip' do
      get :show, id: banned_ip1.id.to_s
      expect(json['body']['_id']).to eq banned_ip1.id.to_s
      expect(json['body']['address']).to eq banned_ip1.address
      expect(json['body']['created_at']).to be_present
      expect(json['body']['updated_at']).to be_present   
      response.status.should be RequestCodes::SUCCESS
    end

    it 'returns a friendly error when banned_ip not found by id' do
      get :show, id: -1
      response.status.should be RequestCodes::NOT_FOUND
    end 
  end

  describe '#create' do
  
    it 'creates a banned ip' do
      expect {
        post :create, banned_ip: { address: '192.168.0.0' }
        expect(response.status).to eq RequestCodes::SUCCESS
        expect(json['body']['address']).to eq '192.168.0.0'
      }.to change { BannedIp.count }.by 1
    end
  end

  describe '#update' do
    
    it 'updates the address of a banned ip' do
      addr = '192.168.0.12'
      banned_ip1
      expect(banned_ip1.address).to_not eq addr
      patch :update, id: banned_ip1.id.to_s, banned_ip: { address: addr }
      expect(json['body']['address']).to eq addr
      banned_ip1.reload
      expect(banned_ip1.address).to eq addr
    end
  end

  describe '#delete' do
    
    it 'deletes a banned ip' do
      banned_ip1
      expect {
        delete :destroy, id: banned_ip1.id.to_s
        expect(json['body']['_id']).to eq banned_ip1.id.to_s
      }.to change { BannedIp.count }.by(-1)
    end
  end
end
