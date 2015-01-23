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
end
