# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :announcement do
    sequence(:title) { |n| "title_#{n}" }
    sequence(:content) { |n| "content_#{n}" }
  end
end
