FactoryGirl.define do
  factory :ticket do
    sequence(:subject) { |n| "ticket #{n}" }
    content 'This is some random content'

    before :create do |ticket, evaluator|
      ticket.user = evaluator.user || FactoryGirl.create(:user)
    end
  end
end
