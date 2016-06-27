# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :literature do
    short_citation "MyString"
    year "MyString"
    author "MyString"
    long_citation "MyText"
    url "MyString"
    approved false
    bibtex "MyText"
  end
end
