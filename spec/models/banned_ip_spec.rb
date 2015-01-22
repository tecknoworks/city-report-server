require 'spec_helper'

describe BannedIp do
  let(:banned_ip) { create :banned_ip }

  it 'works' do
    expect {
      banned_ip = create :banned_ip
      expect(banned_ip).to be_valid
    }.to change { BannedIp.count }.by 1
  end

  it 'validates the presence of the address' do
    banned_ip = build :banned_ip, address: nil
    expect(banned_ip).to_not be_valid
  end
end
