# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :phase do
    sequence(:name) { |n| "phase_#{n}" }
    culture

    factory :phase_with_samples do
      after_build do |phase|
        phase.samples << FactoryGirl.create_list(:sample,2, :phase => phase)
      end
    end

#    after_create do |a|
#      if a.samples.blank?
#        FactoryGirl.create_list(:sample,2, :phase => a)
#      end
#    end
#    f.sequence(:abreviation) { |n| "abreviation#{n}" }
  end
end
