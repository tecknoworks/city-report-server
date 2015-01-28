require 'spec_helper'

describe BannedIp do
  it 'works' do
    expect {
      create :banned_ip 
    }.to change { BannedIp.count }.by 1
  end

  it 'validates the presence of the address' do
    banned_ip = build :banned_ip, address: nil
    expect(banned_ip).to_not be_valid
  end

  it 'does not allow duplicate addresses' do
    Issue.delete_all
    
    address = "123.123.123.123" 
    banned_ip = build :banned_ip, address: address
    expect(banned_ip).to be_valid
    
    issue2 = create :issue, lat: 45.768322, lon: 23.595002, address: address
    banned_ip = build :banned_ip, address: address
    expect(banned_ip).to_not be_valid
  end

  it 'validates the format of the address' do
    def valid_ip address
      banned_ip = build :banned_ip, address: address
      expect(banned_ip).to be_valid
    end

    def invalid_ip address
      banned_ip = build :banned_ip, address: address
      expect(banned_ip).to_not be_valid
    end

    invalid_ip 'hello'
    invalid_ip ''
    invalid_ip '299.299.299.299'
    invalid_ip 'google.com'
    invalid_ip '1.-2.-3.0' 
    invalid_ip 'a.b.c.d'
    invalid_ip '129.168.0.'
    invalid_ip '129.168.0'

    valid_ip '192.168.0.19'
    valid_ip '192.168.200.192' 
    valid_ip '1.1.2.1'
    valid_ip '0.0.0.0'
  end
 
  it 'allows IPv4 and IPv6 in the address field' do
    b = BannedIp.create(address: "11.11.11.11")   
    b.ip_v4.should be_nil
    b.ip_v6.should be_nil
  end

  it 'knows if it is IPv4' do
    banned_ip = create :banned_ip
    expect(banned_ip.ip_v4?).to be true
  end

  it 'knows if it is IPv6' do 
    banned_ip = create :banned_ip_v6
    expect(banned_ip.ip_v6?).to be true
  end
end
