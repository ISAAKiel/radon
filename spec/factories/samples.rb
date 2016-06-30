# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sample do
    sequence(:lab_nr) { |n| "#{n}" }
    sequence(:bp) { |n| n }
    sequence(:std) { |n| n }
    sequence(:delta_13_c) { |n| n }

    sequence(:comment) { |n| "comment_#{n}" }
    sequence(:feature) { |n| "feature_#{n}" }
    approved true
    sequence(:contact_e_mail) { |n| "contact_e_mail#{n}@nowhere.com" }
    sequence(:creator_ip) { |n| "creator_ip_#{n}" }
    
    prmat {FactoryGirl.create(:prmat)}
    phase
    lab {FactoryGirl.create(:lab)}
    feature_type {FactoryGirl.create(:feature_type)}
    site {FactoryGirl.create(:site)}
    right
    factory :public_sample do |ps|
      ps.right {FactoryGirl.create(:public_right)}
    end
    factory :private_sample do |ps|
      ps.right {FactoryGirl.create(:private_right)}
    end
#    right { Right.where(id: 1).first || association(:right) }
    dating_method
  end
end
