# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :announcement do
    sequence(:title) { |n| "title_#{n}" }
    sequence(:content) { |n| "content_#{n}" }
  end
end
