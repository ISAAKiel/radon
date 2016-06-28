FactoryGirl.define do
  factory :page do |f|
    f.sequence(:name) { |n| "foo#{n}" }
    f.sequence(:content) { |n| "bar#{n}" }
    initialize_with { Page.find_or_create_by(name: name)}
  end
end
