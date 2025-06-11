# Create sample products
puts 'Creating sample products...'

# Create a retail store if it doesn't exist
retail_store = Spree::Store.find_or_create_by(code: 'retail') do |store|
  store.name = 'Bates Embroidery - Retail'
  store.url = 'retail.batesembroidery.com'
  store.mail_from_address = 'orders@batesembroidery.com'
  store.default_currency = 'USD'
  store.default = true
end

# Create a B2B store if it doesn't exist
b2b_store = Spree::Store.find_or_create_by(code: 'b2b') do |store|
  store.name = 'Bates Embroidery - B2B Wholesale'
  store.url = 'b2b.batesembroidery.com'
  store.mail_from_address = 'wholesale@batesembroidery.com'
  store.default_currency = 'USD'
  store.default = false
end

# Create shipping category if it doesn't exist
shipping_category = Spree::ShippingCategory.first || Spree::ShippingCategory.create!(name: 'Default')

# Create sample products
products_data = [
  {
    name: 'Classic Cotton T-Shirt',
    description: 'High-quality 100% cotton t-shirt perfect for embroidery',
    price: 15.99,
    sku: 'COTTON-TEE-001'
  },
  {
    name: 'Premium Polo Shirt',
    description: 'Professional polo shirt ideal for corporate branding',
    price: 24.99,
    sku: 'POLO-001'
  },
  {
    name: 'Baseball Cap',
    description: 'Adjustable baseball cap with embroidery-ready front panel',
    price: 12.99,
    sku: 'CAP-001'
  }
]

products_data.each do |product_data|
  # Find by master variant SKU instead
  existing_variant = Spree::Variant.find_by(sku: product_data[:sku])
  
  if existing_variant
    product = existing_variant.product
    puts "Product already exists: #{product.name}"
  else
    product = Spree::Product.create!(
      name: product_data[:name],
      description: product_data[:description],
      price: product_data[:price],
      available_on: Time.current,
      shipping_category: shipping_category
    )
    
    # Update the master variant with the SKU
    product.master.update!(
      sku: product_data[:sku],
      price: product_data[:price],
      cost_price: product_data[:price] * 0.6
    )
    
    puts "Created product: #{product.name}"
  end
end

puts 'Sample products created successfully!'
puts "Total products: #{Spree::Product.count}"