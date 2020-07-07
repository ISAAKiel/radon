# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :country do
    sequence(:name) { |n| "country_#{n}" }
    sequence(:abreviation) { |n| "abreviation#{n}"}

    factory :country_with_country_subdivisions do
      after(:create) do |a|
        a.country_subdivisions << FactoryBot.create_list(:country_subdivision, 3, :country => a)
      end
    end
  end

end
