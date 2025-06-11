FactoryBot.define do
  factory :product do
    name { "MyString" }
    description { "MyText" }
    sku { "MyString" }
    price { "9.99" }
    supplier_id { "MyString" }
    supplier_type { "MyString" }
    active { false }
  end
end
