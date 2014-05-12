FactoryGirl.define do
  factory :issue do
    name 'Wow such pothole'
    category Repara.categories.last
    lat 1
    lon 2
    images [{url: 'http://www.google.com/asd.png'}]
  end

end
