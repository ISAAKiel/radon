# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :site do |f|
    f.sequence(:name) { |n| "site_#{n}" }
    f.sequence(:parish) { |n| "parish_#{n}" }
    f.sequence(:district) { |n| "district_#{n}" }
    f.sequence(:lat) { |n| n/2 }
    f.sequence(:lng) { |n| n/2 }

    country_subdivision

    factory :site_with_samples do
      after(:create) do |site|
        if site.samples.length==0
          site.samples << FactoryGirl.build(:sample, :site => site)
        end
      end
    end
#    f.sequence(:abreviation) { |n| "abreviation#{n}" }
  end
end
