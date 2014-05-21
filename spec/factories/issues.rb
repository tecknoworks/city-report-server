FactoryGirl.define do
  factory :issue do
    name 'Wow such pothole'
    category Repara.categories.last
    lat 1
    lon 2
    images [{url: "#{Repara.base_url}images/uploads/original/asd.png"}]
  end
end
