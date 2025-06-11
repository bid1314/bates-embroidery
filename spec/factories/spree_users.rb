FactoryBot.define do
  factory :user, class: 'Spree::User' do
    email { Faker::Internet.email }
    password { 'password123' }
    password_confirmation { 'password123' }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    confirmed_at { Time.current }

    trait :b2b_customer do
      after(:create) do |user|
        b2b_role = Spree::Role.find_or_create_by(name: 'b2b_customer')
        user.spree_roles << b2b_role unless user.spree_roles.include?(b2b_role)
      end
    end

    trait :admin do
      after(:create) do |user|
        admin_role = Spree::Role.find_or_create_by(name: 'admin')
        user.spree_roles << admin_role unless user.spree_roles.include?(admin_role)
      end
    end
  end
end