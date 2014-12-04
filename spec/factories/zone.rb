FactoryGirl.define do
  sequence :zone_name do |n|
    "zone#{n}"
  end

  factory :zone do
    name { generate :category_name }
  end
end
