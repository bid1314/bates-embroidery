# Bates Embroidery E-commerce Platform

## Overview

This is a custom e-commerce platform built for Bates Embroidery, featuring multi-store capabilities, product customization, supplier integrations, and AI-powered features. The platform supports both retail and B2B customers with role-based access and pricing.

## Current Implementation Status

### ✅ COMPLETED FEATURES

#### Core Technology Stack
- **Framework**: Ruby on Rails 7.2.2
- **Ruby Version**: 3.1.2
- **Database**: PostgreSQL 15
- **Background Jobs**: Redis + Sidekiq
- **Authentication**: Devise
- **Authorization**: CanCanCan
- **Frontend**: Bootstrap 5.3.0 + ERB templates
- **File Storage**: Active Storage (configured for AWS S3)
- **Email**: SendGrid integration
- **API Clients**: HTTParty, Faraday

#### Implemented Features
- ✅ Product catalog with search and filtering
- ✅ User authentication and role-based access (Customer, B2B Customer, Admin)
- ✅ Multi-store setup (Retail and B2B stores)
- ✅ Product customization interface (placeholder for tui.image-editor integration)
- ✅ Responsive Bootstrap UI
- ✅ Database schema with proper associations
- ✅ Seed data with sample products and users
- ✅ Basic API endpoints structure

### 🚧 PLANNED FEATURES (Not Yet Implemented)

#### Core Technology Stack (Planned)
- **E-commerce Engine**: Spree Commerce (removed due to compatibility issues)
- **Multi-tenancy**: Apartment gem
- **Admin Interface**: Bullet Train
- **Image Editing**: TUI Image Editor (JavaScript)
- **Email Automation**: Brevo API + Mautic (open-source)
- **Containerization**: Docker & Docker Compose

## How to Run the Application

### Prerequisites
- Ruby 3.1.2
- PostgreSQL 15
- Redis (for Sidekiq)
- Node.js (for asset compilation)

### Quick Start

1. **Clone and setup**
   ```bash
   cd /workspace/bates-embroidery
   bundle install
   ```

2. **Database setup**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

3. **Start the application**
   ```bash
   # Start Rails server
   rails server -b 0.0.0.0 -p 12000
   
   # In another terminal, start Sidekiq for background jobs
   bundle exec sidekiq
   ```

4. **Access the application**
   - Local: http://localhost:12000
   - External: https://work-1-wjajrebstcyljkfs.prod-runtime.all-hands.dev

### Default Users (from seeds)
- **Admin**: admin@batesembroidery.com / password123
- **Customer**: customer@example.com / password123
- **B2B Customer**: b2b@company.com / password123

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