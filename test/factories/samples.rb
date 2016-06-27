# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sample do
    lab nil
    lab_nr "MyString"
    bp 1
    std 1
    delta_13_c 1.5
    delta_13_c_std 1.5
    prmat nil
    prmat_comment "MyText"
    comment "MyText"
    feature "MyString"
    feature_type nil
    phase nil
    site nil
    approved false
    right nil
    dating_method nil
    contact_e_mail "MyString"
    creator_ip "MyString"
  end
end
