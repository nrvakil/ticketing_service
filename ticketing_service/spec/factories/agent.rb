FactoryGirl.define do
  factory :agent do
    sequence(:name) { |n| "name #{n}" }
    sequence(:email) { |n| "email#{n}@emails.com" }
    password 'pwd'
    status 'approved'
  end
end
