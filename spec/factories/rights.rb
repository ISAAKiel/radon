# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :right do |f|
    f.sequence(:name) { |n| "right_#{n}" }
    f.sequence(:id) { |n| n }
    initialize_with { Right.find_or_create_by(id: id)}
  end
end
