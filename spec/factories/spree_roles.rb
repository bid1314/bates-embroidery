FactoryBot.define do
  factory :role, class: 'Spree::Role' do
    name { 'customer' }

    trait :b2b_customer do
      name { 'b2b_customer' }
    end

    trait :admin do
      name { 'admin' }
    end
  end
end