# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :sample do
    sequence(:lab_nr) { |n| "#{n}" }
    sequence(:bp) { |n| n }
    sequence(:std) { |n| n }
    sequence(:delta_13_c) { |n| n }

    sequence(:comment) { |n| "comment_#{n}" }
    sequence(:feature) { |n| "feature_#{n}" }
    approved {true}
    sequence(:contact_e_mail) { |n| "contact_e_mail#{n}@nowhere.com" }
    sequence(:creator_ip) { |n| "creator_ip_#{n}" }
    
    prmat {FactoryBot.create(:prmat)}
    phase
    lab {FactoryBot.create(:lab)}
    feature_type {FactoryBot.create(:feature_type)}
    site {FactoryBot.create(:site)}
    right
    factory :public_sample do |ps|
      ps.right {FactoryBot.create(:public_right)}
    end
    factory :private_sample do |ps|
      ps.right {FactoryBot.create(:private_right)}
    end
#    right { Right.where(id: 1).first || association(:right) }
    dating_method
  end
end
