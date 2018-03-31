FactoryBot.define do
  company = FactoryBot.create(:company)

  factory :trip do
    association :vehicle, company: company
    association :user, company: company
    company company
    start_at Time.now
    end_at Time.now + 2.hours
    distance 1
  end
end
