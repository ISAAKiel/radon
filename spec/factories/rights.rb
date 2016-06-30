# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :right do |f|
    f.sequence(:name) { |n| "right_#{n}" }
    f.sequence(:id) { |n| n }
    factory :public_right do |pr|
      pr.id 1
    end
    factory :private_right do |pr|
      pr.id 2
    end
    initialize_with { Right.find_or_create_by(id: id)}
  end
end
