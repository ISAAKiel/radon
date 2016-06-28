# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :dating_method do |f|
    f.sequence(:name) { |n| "dating_method_#{n}" }
  end
end
