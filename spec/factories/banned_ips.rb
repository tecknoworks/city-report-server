FactoryGirl.define do
  factory :banned_ip do
    ip_address '192.168.0.11'
  end
  
  factory 'banned_ip2', parent: :banned_ip do
    ip_address '200.132.2.10'
  end

  factory 'banned_ip_v6', parent: :banned_ip do
    ip_address '2620:0:1cfe:face:b00c::3'
  end
end
  
