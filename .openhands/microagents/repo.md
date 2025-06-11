# Bates Embroidery E-commerce Platform

## Overview

The Bates Embroidery E-commerce Platform is a comprehensive multi-store e-commerce solution built with Rails 7.2.2 and Spree Commerce 5.0.4. It supports both retail and B2B operations with advanced product customization capabilities, supplier integrations, and AI-powered embroidery estimation.

## Current Implementation Status

### ✅ COMPLETED FEATURES

#### Core Technology Stack
- **Framework**: Ruby on Rails 7.2.2.1
- **Ruby Version**: 3.1.2
- **E-commerce Engine**: Spree Commerce 5.0.4 ✅ **FULLY INTEGRATED**
- **Database**: PostgreSQL 17.5
- **Cache/Sessions**: Redis 7.0
- **Authentication**: Devise with Spree integration
- **Authorization**: Spree role-based system
- **Frontend**: Stimulus, Turbo, Bootstrap-compatible styling
- **Rich Content**: Action Text with Trix editor
- **Background Jobs**: Sidekiq
- **File Storage**: Active Storage (configured for AWS S3)
- **API Clients**: HTTParty, Faraday
- **Testing**: RSpec, Capybara

#### Implemented Features
- ✅ **Full Spree Commerce Integration** - Complete e-commerce platform
- ✅ **Shopping Cart System** - Add/remove items, quantity updates, AJAX functionality
- ✅ **Product Management** - Full Spree product catalog with variants
- ✅ **User Authentication** - Devise + Spree user management
- ✅ **Multi-store Setup** - Retail and B2B store configurations
- ✅ **Order Management** - Complete order processing workflow
- ✅ **Payment Processing** - Spree payment system integration
- ✅ **Inventory Management** - Real-time stock tracking
- ✅ **Admin Interface** - Spree admin panel access
- ✅ **API Endpoints** - RESTful cart and product APIs
- ✅ **Database Schema** - 107 Spree migrations successfully applied
- ✅ **Seed Data** - Admin, customer, and B2B user accounts
- ✅ **Responsive Design** - Mobile-friendly interface

### 🚧 NEXT PRIORITIES

#### Immediate Development Tasks
- **TUI Image Editor Integration** - Live 2D customization interface
- **Supplier API Integration** - SanMar and S&S Activewear APIs
- **Enhanced Admin Interface** - Drag-and-drop page builder
- **AI Embroidery Estimation** - Stitch count and cost calculation

## How to Run the Application

### Prerequisites
- Ruby 3.1.2
- PostgreSQL 17.5
- Redis 7.0 (for Sidekiq and sessions)
- Node.js (for asset compilation)

### System Dependencies Installation
```bash
# Update system packages
sudo apt-get update

# Install PostgreSQL 17.5
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ bookworm-pgdg main" > /etc/apt/sources.list.d/pgdg.list
apt-get update && apt-get install -y postgresql-17 postgresql-client-17

# Install Redis
apt-get install -y redis-server

# Install build dependencies
apt-get install -y build-essential libpq-dev nodejs npm
```

### Database Setup
```bash
# Start PostgreSQL service
service postgresql start

# Create database user and databases
sudo -u postgres createuser -s root
sudo -u postgres psql -c "ALTER USER root WITH PASSWORD 'password';"
sudo -u postgres createdb bates_embroidery_development
sudo -u postgres createdb bates_embroidery_test
```

### Application Setup

1. **Clone and install dependencies**
   ```bash
   cd /workspace/bates-embroidery
   bundle install
   ```

2. **Database setup with Spree**
   ```bash
   # Run all migrations (includes 107 Spree migrations)
   bundle exec rails db:migrate
   
   # Seed database with sample data
   bundle exec rails db:seed
   ```

3. **Start services**
   ```bash
   # Start Redis
   service redis-server start
   
   # Start Rails server (configured for web panel access)
   bundle exec rails server -b 0.0.0.0 -p 12000
   
   # In another terminal, start Sidekiq for background jobs
   bundle exec sidekiq
   ```

4. **Access the application**
   - **Web Panel**: https://work-1-wjajrebstcyljkfs.prod-runtime.all-hands.dev
   - **Local**: http://localhost:12000
   - **Spree Admin**: http://localhost:12000/admin
   - **Sidekiq Monitor**: http://localhost:12000/sidekiq (development only)

### Default User Accounts
- **Admin**: admin@batesembroidery.com / password123
- **Customer**: customer@example.com / password123
- **B2B Customer**: b2b@company.com / password123

### Store Access
- **Retail Store**: Main storefront (default)
- **B2B Store**: Accessible with B2B customer login
- **Admin Panel**: Full Spree admin interface

## Database Schema

### Current Tables

#### Users
- `id` (Primary Key)
- `email` (Unique)
- `encrypted_password`
- `role` (Integer: 0=customer, 1=b2b_customer, 2=admin)
- Devise fields (reset_password_token, etc.)

#### Stores
- `id` (Primary Key)
- `name` (String)
- `subdomain` (String, Unique)
- `domain` (String)
- `active` (Boolean)
- `settings` (JSON)

#### Products
- `id` (Primary Key)
- `name` (String)
- `description` (Text)
- `sku` (String, Unique)
- `price` (Decimal)
- `supplier_id` (String)
- `supplier_type` (Integer: 0=sanmar, 1=ss_activewear, 2=custom)
- `active` (Boolean)

#### Customizations
- `id` (Primary Key)
- `user_id` (Foreign Key)
- `product_id` (Foreign Key)
- `design_data` (Text - JSON storage for design information)
- `ai_estimation` (Text - AI-generated stitch estimation)
- `status` (String)

#### Orders
- `id` (Primary Key)
- `user_id` (Foreign Key)
- `store_id` (Foreign Key)
- `total` (Decimal)
- `status` (String)

## Current Features

### ✅ Multi-Store Setup (Basic)
- **Retail Store** configuration in database
  - Open pricing for all visitors
  - Standard product markup
  - Public product catalog
  
- **B2B Store** configuration in database
  - Pricing visible only to approved wholesale customers
  - Role-based access control
  - Bulk ordering capabilities (planned)
  - Custom pricing tiers (planned)

### ✅ Product Management
- Product catalog with images
- Search and filtering by supplier
- Product details with customization interface
- Supplier type support (SanMar, S&S Activewear, Custom)

### ✅ User Management
- Devise authentication
- Role-based access (Customer, B2B Customer, Admin)
- User registration and login

### ✅ Basic Customization System
- Customization model for storing user designs
- Basic customization interface (ready for tui.image-editor integration)
- User-specific customization storage

## Planned Features (High Priority)

### 🚧 Live 2D Customization
- **TUI Image Editor Integration**
  - Real-time text overlay
  - Image scaling and positioning
  - Logo placement and manipulation
  - Color picker for stitching
  
### 🚧 AI-Powered Features
- **Embroidery Stitch Estimation**
  - AI-based stitch count calculation
  - Cost estimation based on complexity
  - Design analysis and recommendations

### 🚧 Supplier API Integration
- **SanMar API**
  - Product data synchronization
  - Inventory updates
  - Pricing information
  
- **S&S Activewear API**
  - Product catalog import
  - Real-time inventory
  - Automated updates

### 🚧 E-commerce Features
- Shopping cart functionality
- Checkout process
- Payment gateway integration
- Order management system

## Planned Features (Medium Priority)

### 🚧 Multi-tenancy with Apartment
- Complete store separation
- Subdomain-based routing
- Store-specific customizations

### 🚧 Admin Interface
- Product management dashboard
- User management
- Order processing
- Store configuration
- Live site customizer (Elementor-style)

### 🚧 Advanced B2B Features
- Approval workflow for B2B customers
- Volume pricing tiers
- Custom pricing per customer
- Bulk ordering interface

### 🚧 Email Automation
- Brevo API integration
- Order confirmation emails
- Marketing automation
- Mautic integration option

## Planned Features (Low Priority)

### 🚧 Customer Stores
- Ability to create stores for customers
- Preset designs and configurations
- Customer-specific branding

### 🚧 Printavo Integration
- Production workflow integration
- RFQ (Request for Quote) checkout path
- Order tracking and management

### 🚧 Advanced User Features
- "My Logos" / "My Brand" feature
- Advanced search and filtering
- Product recommendations
- Inventory management

## Environment Configuration

### Required Environment Variables

Create a `.env` file with the following variables:

```env
# Database
DATABASE_URL=postgresql://root:password@localhost:5432/bates_embroidery_development

# Redis
REDIS_URL=redis://localhost:6379/0

# AWS S3 (for file uploads)
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_REGION=us-east-1
AWS_S3_BUCKET=your-bucket-name

# SendGrid (for emails)
SENDGRID_API_KEY=your_sendgrid_api_key

# Supplier APIs (for future implementation)
SANMAR_API_KEY=your_sanmar_api_key
SANMAR_API_URL=https://api.sanmar.com
SS_ACTIVEWEAR_API_KEY=your_ss_api_key
SS_ACTIVEWEAR_API_URL=https://api.ssactivewear.com

# Brevo API (for email automation)
BREVO_API_KEY=your_brevo_api_key

# Application
SECRET_KEY_BASE=your_secret_key_base
```

## API Endpoints (Current)

### Products API
- `GET /api/v1/products` - List all products
- `GET /api/v1/products/:id` - Get specific product

### Customizations API
- `POST /api/v1/customizations` - Create customization
- `GET /api/v1/customizations/:id` - Get customization
- `PUT /api/v1/customizations/:id` - Update customization
- `DELETE /api/v1/customizations/:id` - Delete customization

### Supplier Integration API (Planned)
- `POST /api/v1/suppliers/sync_sanmar` - Sync SanMar products
- `POST /api/v1/suppliers/sync_ss_activewear` - Sync S&S Activewear products

## Testing

### Running Tests
```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/models/user_spec.rb

# Run with coverage
COVERAGE=true bundle exec rspec
```

### Test Structure
- Model tests: `spec/models/`
- Controller tests: `spec/controllers/`
- Feature tests: `spec/features/`
- API tests: `spec/requests/`

## Development Guidelines

### Code Style
- Follow Rails conventions
- Use strong parameters for all form inputs
- Implement proper error handling
- Write tests for all new features

### Security Considerations
- All user inputs are sanitized
- CSRF protection enabled
- Secure headers configured
- Environment variables for sensitive data
- Role-based access control

### Performance
- Database indexes on frequently queried columns
- Background jobs for heavy operations
- Image optimization for product photos
- Caching strategies for product catalogs

## Next Steps for Development

### Immediate (Week 1-2)
1. **Shopping Cart Implementation**
   - Add cart model and functionality
   - Cart persistence for logged-in users
   - Session-based cart for guests

2. **TUI Image Editor Integration**
   - Install and configure tui.image-editor
   - Create customization interface
   - Save/load customization data

3. **Basic Admin Interface**
   - Product management CRUD
   - User management
   - Order viewing

### Short Term (Week 3-4)
1. **Supplier API Integration**
   - SanMar API client implementation
   - S&S Activewear API client
   - Background job for data synchronization

2. **Payment Integration**
   - Stripe or PayPal integration
   - Checkout process
   - Order confirmation

3. **Email System**
   - Order confirmation emails
   - User registration emails
   - Basic email templates

### Medium Term (Month 2-3)
1. **Multi-tenancy with Apartment**
   - Store separation
   - Subdomain routing
   - Store-specific configurations

2. **AI Stitch Estimation**
   - Research and implement AI model
   - Cost calculation based on design complexity
   - Integration with customization interface

3. **Advanced B2B Features**
   - Approval workflow
   - Volume pricing
   - Custom pricing per customer

## Support and Documentation

### Getting Help
- Check existing documentation
- Review code comments
- Create issues for bugs or feature requests

### Contributing
1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

This project is proprietary software for Bates Embroidery.

---

**Last Updated**: June 11, 2025  
**Version**: 1.0.0-alpha  
**Current Status**: Basic Rails application with authentication, product catalog, and customization framework  
**Next Priority**: Shopping cart, TUI image editor integration, supplier API implementation