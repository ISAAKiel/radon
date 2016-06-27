# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :country_subdivision do
    name "MyString"
    position 1
    country nil
  end
end
