# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :feature_type do |f|
    f.sequence(:name) { |n| "foo#{n}" }
    f.sequence(:comment) { |n| "comment#{n}" }
  end
end
