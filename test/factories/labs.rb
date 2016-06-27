# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lab do
    name "MyString"
    dating_method nil
    lab_code "MyString"
    country "MyString"
    active false
    position 1
  end
end
