FactoryGirl.define do
  factory :banned_ip do
    address '192.168.0.11'
  end

  factory 'banned_ip_v6', parent: :banned_ip do
    address '2620:0:1cfe:face:b00c::3'
  end
end
  
