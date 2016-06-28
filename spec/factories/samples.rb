# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sample do
    sequence(:lab_nr) { |n| "#{n}" }
    sequence(:bp) { |n| n }
    sequence(:std) { |n| n }
    sequence(:delta_13_c) { |n| n }

    sequence(:comment) { |n| "comment_#{n}" }
    sequence(:feature) { |n| "feature_#{n}" }
    approved { [true,false].sample }
    sequence(:contact_e_mail) { |n| "contact_e_mail#{n}@nowhere.com" }
    sequence(:creator_ip) { |n| "creator_ip_#{n}" }
    
    prmat
    phase
    lab
    feature_type
    site
    association :right, id: 1
    dating_method
  end
end
