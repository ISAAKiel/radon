# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :literature do
    sequence(:short_citation) { |n| "short_citation_#{n}" }
    sequence(:year) { |n| "#{n}"}
    sequence(:author) { |n| "author_#{n}" }
    sequence(:long_citation) { |n| "long_citation_#{n}" }
    sequence(:url) { |n| "url_#{n}" }
    sequence(:approved) { |n| n.even? ? true : false }

  end

end
