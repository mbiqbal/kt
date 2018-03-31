FactoryBot.define do
  factory :user do
    name "MyString"
    association :company, factory: :company
    role 0
  end
end
