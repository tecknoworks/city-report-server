# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :issue do |f|
    f.title "Groapa in mijlocul centrului"
    f.latitude 1.5
    f.longitude 1.5
    f.category { FactoryGirl.create(:category) }
    f.attachment FactoryGirl.create(:attachment)
  end
  factory :issue_no_category, :class => Issue do |f|
    f.title "Groapa in mijlocul centrului"
    f.latitude 1.5
    f.longitude 1.5
  end
end
