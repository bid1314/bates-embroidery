class Retail::HomeController < ApplicationController
  
  def index
    @featured_products = Spree::Product.available.limit(8)
    @store_name = "Bates Embroidery - Custom Apparel & Embroidery"
    @store_tagline = "Professional Custom Embroidery, Screen Printing & Promotional Products"
    
    # Retail-specific content
    @services = [
      {
        title: "Custom Embroidery",
        description: "Professional embroidery services for apparel, hats, and accessories",
        icon: "🧵"
      },
      {
        title: "Screen Printing",
        description: "High-quality screen printing for t-shirts, hoodies, and more",
        icon: "🎨"
      },
      {
        title: "Promotional Products",
        description: "Custom promotional items for your business or event",
        icon: "🎁"
      },
      {
        title: "Design Services",
        description: "Professional design and digitizing services",
        icon: "✏️"
      }
    ]
  end
end