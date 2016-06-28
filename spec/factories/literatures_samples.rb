# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :literatures_sample do
    literature
    sample
    sequence(:pages) {|n| "pages_#{n}" }
  end

end
