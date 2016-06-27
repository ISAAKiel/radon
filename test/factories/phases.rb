# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phase do
    name "MyString"
    culture nil
    approved false
    position 1
  end
end
