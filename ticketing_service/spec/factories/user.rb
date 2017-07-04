FactoryGirl.define do
  factory :user do
    sequence(:name) { |n| "name #{n}" }
    sequence(:email) { |n| "email#{n}@emails.com" }
    password 'pwd'

    trait :invalid_parameters do
      name nil
      email nil
    end

    factory :invalid_user, traits: [:invalid_parameters]
  end
end
