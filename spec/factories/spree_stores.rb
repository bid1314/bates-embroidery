FactoryBot.define do
  factory :store, class: 'Spree::Store' do
    name { 'Test Store' }
    url { 'example.com' }
    mail_from_address { 'test@example.com' }
    default_currency { 'USD' }
    code { 'test' }
    default { false }

    trait :retail do
      name { 'Bates Embroidery - Retail' }
      url { 'retail.batesembroidery.com' }
      mail_from_address { 'orders@batesembroidery.com' }
      code { 'retail' }
      default { true }
    end

    trait :b2b do
      name { 'Bates Embroidery - B2B Wholesale' }
      url { 'b2b.batesembroidery.com' }
      mail_from_address { 'wholesale@batesembroidery.com' }
      code { 'b2b' }
      default { false }
    end
  end
end