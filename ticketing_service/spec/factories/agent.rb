FactoryGirl.define do
  factory :agent do
    sequence(:name) { |n| "agent name #{n}" }
    sequence(:email) { |n| "agent-email#{n}@emails.com" }
    password 'pwd'
    status 'approved'
  end
end
