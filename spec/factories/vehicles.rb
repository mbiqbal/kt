FactoryBot.define do
  factory :vehicle do
    registration_name Random.rand(1000)
    association :company, factory: :company

  end
end
