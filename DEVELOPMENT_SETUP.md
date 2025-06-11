# Bates Embroidery Development Setup

## Quick Start

### Prerequisites
- Ruby 3.1.2+
- PostgreSQL 17.5+
- Redis 7.0.15+
- Node.js (for asset compilation)

### 1. Clone and Setup
```bash
git clone https://github.com/bid1314/bates-embroidery.git
cd bates-embroidery
```

### 2. Install Dependencies
```bash
# Install Ruby gems
bundle install

# Install JavaScript dependencies (if needed)
# npm install (currently using importmap, so not needed)
```

### 3. Database Setup
```bash
# Create and setup database
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed

# Install Spree (if not already done)
bundle exec rails generate spree:install --user_class=Spree::User
bundle exec rails generate spree:auth:install
bundle exec rails generate spree_gateway:install
```

### 4. Start Services

#### Start Redis (required for Spree and Sidekiq)
```bash
# On Ubuntu/Debian
sudo systemctl start redis-server

# Or using Docker
docker run -d -p 6379:6379 redis:7.0.15-alpine

# Or if Redis is already installed
redis-server
```

#### Start Rails Server
```bash
# Development server
bundle exec rails server -b 0.0.0.0 -p 12001

# Or using the provided script
./bin/dev
```

### 5. Access the Application

#### Local Development (without subdomains)
- **Main Site**: http://localhost:12001
- **Retail Store**: http://localhost:12001 (default)
- **B2B Store**: http://localhost:12001 (requires subdomain setup)
- **Spree Admin**: http://localhost:12001/admin
- **Sidekiq Dashboard**: http://localhost:12001/sidekiq

#### With Subdomain Setup (Production-like)
Add to your `/etc/hosts` file:
```
127.0.0.1 retail.localhost
127.0.0.1 b2b.localhost
```

Then access:
- **Retail Store**: http://retail.localhost:12001
- **B2B Store**: http://b2b.localhost:12001

## Development Workflow

### Running Tests
```bash
# Run all tests
bundle exec rspec

# Run specific test files
bundle exec rspec spec/controllers/
bundle exec rspec spec/models/

# Run with coverage
COVERAGE=true bundle exec rspec
```

### Code Quality
```bash
# Run RuboCop
bundle exec rubocop

# Run Brakeman security scan
bundle exec brakeman

# Fix RuboCop issues automatically
bundle exec rubocop -a
```

### Background Jobs
```bash
# Start Sidekiq for background job processing
bundle exec sidekiq

# Monitor jobs at http://localhost:12001/sidekiq
```

## Environment Configuration

### Required Environment Variables
Create a `.env` file in the project root:

```bash
# Database
DATABASE_URL=postgresql://username:password@localhost:5432/bates_embroidery_development

# Redis
REDIS_URL=redis://localhost:6379/0

# Rails
RAILS_ENV=development
SECRET_KEY_BASE=your_secret_key_here

# Email (for development)
BREVO_API_KEY=your_brevo_api_key
SENDGRID_API_KEY=your_sendgrid_api_key

# Supplier APIs (for development)
SANMAR_API_KEY=your_sanmar_api_key
SS_ACTIVEWEAR_API_KEY=your_ss_activewear_api_key

# AWS S3 (for file uploads)
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_REGION=us-east-1
AWS_S3_BUCKET=your-bucket-name
```

### Development vs Production
- **Development**: Uses local PostgreSQL and Redis
- **Production**: Uses environment variables for all services
- **Testing**: Uses separate test database

## Troubleshooting

### Common Issues

#### Server Won't Start
```bash
# Check if port is in use
sudo lsof -i :12001

# Kill existing Rails processes
pkill -f "rails server"

# Remove PID file
rm -f tmp/pids/server.pid

# Check database connection
bundle exec rails db:migrate:status
```

#### Database Issues
```bash
# Reset database
bundle exec rails db:drop db:create db:migrate db:seed

# Check database status
bundle exec rails db:migrate:status

# Run specific migration
bundle exec rails db:migrate:up VERSION=20231201000000
```

#### Redis Issues
```bash
# Check Redis status
redis-cli ping

# Start Redis
redis-server

# Check Redis logs
tail -f /var/log/redis/redis-server.log
```

#### Asset Issues
```bash
# Precompile assets
bundle exec rails assets:precompile

# Clear asset cache
bundle exec rails assets:clobber

# Check importmap
bundle exec rails importmap:install
```

### Debugging

#### Rails Console
```bash
# Start Rails console
bundle exec rails console

# Check current environment
Rails.env

# Test Spree setup
Spree::Store.all
Spree::User.all
```

#### Logs
```bash
# Development logs
tail -f log/development.log

# Test logs
tail -f log/test.log

# Sidekiq logs
tail -f log/sidekiq.log
```

## Development Features

### Multi-Store Architecture
- **Retail Store**: Public-facing e-commerce
- **B2B Store**: Wholesale portal with authentication
- **Subdomain Routing**: Automatic store detection
- **Role-based Access**: Customer, B2B Customer, Admin roles

### Product Customization
- **Live 2D Editor**: Text and logo placement
- **AI Stitch Estimation**: Cost calculation
- **Design Persistence**: Save to user accounts
- **Cart Integration**: Add customized products

### API Integration
- **SanMar API**: Product catalog sync
- **S&S Activewear API**: Inventory management
- **Brevo API**: Email automation
- **Printavo Integration**: Production workflow

## Contributing

### Git Workflow
1. Create feature branch: `git checkout -b feature/your-feature`
2. Make changes and commit: `git commit -am "Add feature"`
3. Push branch: `git push origin feature/your-feature`
4. Create Pull Request

### Code Standards
- Follow Rails conventions
- Use RuboCop for style
- Write tests for new features
- Update documentation

### Testing Requirements
- Unit tests for models
- Controller tests for endpoints
- Integration tests for workflows
- System tests for user flows

## Production Deployment

### Environment Setup
```bash
# Set production environment
export RAILS_ENV=production

# Precompile assets
bundle exec rails assets:precompile

# Run migrations
bundle exec rails db:migrate

# Start server
bundle exec rails server -e production
```

### Docker Deployment
```bash
# Build image
docker build -t bates-embroidery .

# Run container
docker run -p 3000:3000 -e RAILS_ENV=production bates-embroidery
```

## Support

For development support:
1. Check this documentation
2. Review error logs
3. Check GitHub issues
4. Contact development team