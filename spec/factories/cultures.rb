# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :culture do |f|
    f.sequence(:name) { |n| "culture_#{n}" }

    factory :culture_with_phases do
      after_build do |culture|
        culture.phases << FactoryBot.create_list(:phase_with_samples,2, :culture => culture)
      end
    end
  end
end
