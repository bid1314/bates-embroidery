FactoryBot.define do
  factory :order do
    user { nil }
    store { nil }
    total { "9.99" }
    status { "MyString" }
  end
end
