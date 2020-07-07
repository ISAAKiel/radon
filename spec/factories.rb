FactoryBot.define do

  factory :role do 
    name { "guest" }
    factory :admin_role do |f|
      name { "admin" }
    end
  end

  factory :user do |f|
    without_access_control do 
  #    association :roles, factory: :role, strategy: :build
      f.sequence(:login) { |n| "name_#{n}" }
      f.sequence(:email) { |n| "foo#{n}@example.com" }
      f.sequence(:password) { |n| "secret" }
      f.sequence(:password_confirmation) { |n| "secret" }
      f.roles {[FactoryBot.create(:role)]}
      factory :admin_user do |f|
        f.roles {[FactoryBot.create(:admin_role)]}
      end
    end
  end
end
