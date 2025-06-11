class B2b::HomeController < ApplicationController
  before_action :set_b2b_context
  
  def index
    @featured_products = Spree::Product.available.limit(8)
    @store_name = "Bates Embroidery - B2B Wholesale Portal"
    @store_tagline = "Professional Wholesale Services for Business Partners"
    
    # B2B-specific content
    @services = [
      {
        title: "Wholesale Embroidery",
        description: "Volume embroidery services with competitive wholesale pricing",
        icon: "🧵"
      },
      {
        title: "Bulk Screen Printing",
        description: "Large quantity screen printing for resellers and businesses",
        icon: "🎨"
      },
      {
        title: "Private Label Services",
        description: "White-label solutions for your business",
        icon: "🏷️"
      },
      {
        title: "Account Management",
        description: "Dedicated support for wholesale partners",
        icon: "🤝"
      }
    ]
    
    @volume_tiers = [
      { range: "50-100 pieces", discount: "5%" },
      { range: "101-500 pieces", discount: "10%" },
      { range: "501-1000 pieces", discount: "15%" },
      { range: "1001-10,000 pieces", discount: "20%" },
      { range: "10,000+ pieces", discount: "25%" }
    ]
  end
  
  private
  
  def set_b2b_context
    @is_b2b_store = true
    @show_pricing = user_signed_in? && current_user.has_spree_role?('b2b_customer')
  end
end