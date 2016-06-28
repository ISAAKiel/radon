# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :feature_type do |f|
    f.sequence(:name) { |n| "foo#{n}" }
    f.sequence(:comment) { |n| "comment#{n}" }
  end
end
