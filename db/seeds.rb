# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "Creating stores..."

# Create retail store
retail_store = Store.find_or_create_by!(subdomain: 'retail') do |store|
  store.name = 'Bates Embroidery Retail'
  store.domain = 'retail.batesembroidery.com'
  store.active = true
  store.settings = {
    store_type: 'retail',
    pricing_visible: true,
    markup_percentage: 50
  }
end

# Create B2B store
b2b_store = Store.find_or_create_by!(subdomain: 'b2b') do |store|
  store.name = 'Bates Embroidery B2B'
  store.domain = 'b2b.batesembroidery.com'
  store.active = true
  store.settings = {
    store_type: 'b2b',
    pricing_visible: false,
    requires_approval: true,
    bulk_pricing: true
  }
end

puts "Created #{Store.count} stores"

puts "Creating admin user..."

# Create admin user
admin_user = User.find_or_create_by!(email: 'admin@batesembroidery.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = 'admin'
end

puts "Created admin user: #{admin_user.email}"

puts "Creating sample products..."

# Sample products
products_data = [
  {
    name: 'Classic Cotton T-Shirt',
    description: 'High-quality 100% cotton t-shirt perfect for embroidery',
    sku: 'COTTON-TEE-001',
    price: 15.99,
    supplier_type: 'sanmar',
    supplier_id: 'SM-CT001'
  },
  {
    name: 'Premium Polo Shirt',
    description: 'Professional polo shirt with moisture-wicking fabric',
    sku: 'POLO-SHIRT-001',
    price: 24.99,
    supplier_type: 'sanmar',
    supplier_id: 'SM-PS001'
  },
  {
    name: 'Fleece Hoodie',
    description: 'Comfortable fleece hoodie with front pocket',
    sku: 'HOODIE-001',
    price: 39.99,
    supplier_type: 'ss_activewear',
    supplier_id: 'SS-FH001'
  },
  {
    name: 'Baseball Cap',
    description: 'Adjustable baseball cap with structured crown',
    sku: 'CAP-001',
    price: 18.99,
    supplier_type: 'sanmar',
    supplier_id: 'SM-BC001'
  },
  {
    name: 'Canvas Tote Bag',
    description: 'Durable canvas tote bag for everyday use',
    sku: 'TOTE-001',
    price: 12.99,
    supplier_type: 'custom',
    supplier_id: 'CUSTOM-TB001'
  }
]

products_data.each do |product_data|
  Product.find_or_create_by!(sku: product_data[:sku]) do |product|
    product.name = product_data[:name]
    product.description = product_data[:description]
    product.price = product_data[:price]
    product.supplier_type = product_data[:supplier_type]
    product.supplier_id = product_data[:supplier_id]
    product.active = true
  end
end

puts "Created #{Product.count} products"

puts "Creating sample customers..."

# Sample customers
customer_data = [
  {
    email: 'customer@example.com',
    role: 'customer'
  },
  {
    email: 'b2b@company.com',
    role: 'b2b_customer'
  }
]

customer_data.each do |customer|
  User.find_or_create_by!(email: customer[:email]) do |user|
    user.password = 'password123'
    user.password_confirmation = 'password123'
    user.role = customer[:role]
  end
end

puts "Created #{User.count} users total"

puts "Seed data creation completed!"
puts "Admin login: admin@batesembroidery.com / password123"
puts "Customer login: customer@example.com / password123"
puts "B2B Customer login: b2b@company.com / password123"
