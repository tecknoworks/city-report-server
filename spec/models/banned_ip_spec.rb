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

  it 'validates the format of the address' do
    banned_ip = build :banned_ip, address: 'hello'
    expect(banned_ip).to_not be_valid

    banned_ip = build :banned_ip, address: ''
    expect(banned_ip).to_not be_valid

    banned_ip = build :banned_ip, address: '299.299.299.299'
    expect(banned_ip).to_not be_valid

    banned_ip = build :banned_ip, address: 'google.com'
    expect(banned_ip).to_not be_valid
    
    banned_ip = build :banned_ip, address: '1.-2.-3.0'
    expect(banned_ip).to_not be_valid
    
    banned_ip = build :banned_ip, address: 'a.b.c.d'
    expect(banned_ip).to_not be_valid
    
    banned_ip = build :banned_ip, address: '129.168.0.'
    expect(banned_ip).to_not be_valid

    banned_ip = build :banned_ip, address: '129.168.0'
    expect(banned_ip).to_not be_valid


    banned_ip = build :banned_ip, address: '192.168.0.19'
    expect(banned_ip).to be_valid

    banned_ip = build :banned_ip, address: '192.168.200.192'
    expect(banned_ip).to be_valid

    banned_ip = build :banned_ip, address: '1.1.2.1'
    expect(banned_ip).to be_valid
  end
end
