# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :country_subdivision do
    sequence(:name) { |n| "country_subdivision_#{n}" }
    country

    factory :country_subdivision_with_sites do
      after(:create) do |a|
        a.sites << FactoryBot.create_list(:site, 3, :country_subdivision => a)
      end
    end

  end
end
