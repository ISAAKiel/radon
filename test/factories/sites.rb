# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do
    name "MyString"
    parish "MyString"
    district "MyString"
    country_subdivision nil
    lat 1.5
    lng 1.5
  end
end
