FactoryGirl.define do
  factory :issue do
    name 'Wow such pothole'
    category { Category.to_api.last }
    lat 46.768322
    lon 23.595002
    images [{url: "#{Repara.base_url}images/uploads/original/asd.png"}]
  end
end
