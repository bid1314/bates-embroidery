FactoryBot.define do
  factory :customization do
    user { nil }
    product { nil }
    design_data { "MyText" }
    ai_estimation { "MyText" }
    status { "MyString" }
  end
end
