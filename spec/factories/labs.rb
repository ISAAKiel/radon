# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lab do |f|
    f.sequence(:name) { |n| "lab_#{n}" }
    f.sequence(:country) { |n| "country_#{n}" }
    f.sequence(:lab_code) { |n| "lab_code_#{n}" }
    f.active { [true,false].sample }
    f.dating_method
    factory :lab_with_samples do |f|    
      after_create do |lab|
        lab.samples << FactoryGirl.build_list(:sample,2, :lab => lab)
      end
    end
  end
end
