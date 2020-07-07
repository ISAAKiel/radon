# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :phase do |phase|
    sequence(:name) { |n| "phase_#{n}" }
    culture

    factory :phase_with_samples do
      after_build do |phase|
        phase.samples << FactoryBot.create_list(:sample,2, :phase => phase)
      end
    end

#    after_create do |a|
#      if a.samples.blank?
#        FactoryBot.create_list(:sample,2, :phase => a)
#      end
#    end
#    f.sequence(:abreviation) { |n| "abreviation#{n}" }
  end
end
