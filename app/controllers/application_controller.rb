class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  
  # Skip authentication for public pages - let individual controllers handle it
  before_action :set_current_store
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def set_current_store
    @current_store = determine_current_store
    # Note: Spree handles current store internally, no need to set it manually
  end

  def determine_current_store
    # Check for subdomain-based store routing
    subdomain = request.subdomain
    
    case subdomain
    when 'retail'
      find_or_create_retail_store
    when 'b2b'
      find_or_create_b2b_store
    else
      # Default to retail store for main domain
      find_or_create_retail_store
    end
  end

  def find_or_create_retail_store
    Spree::Store.find_or_create_by(code: 'retail') do |store|
      store.name = 'Bates Embroidery - Retail'
      store.url = 'retail.batesembroidery.com'
      store.mail_from_address = 'orders@batesembroidery.com'
      store.default_currency = 'USD'
      store.default = true
    end
  end

  def find_or_create_b2b_store
    Spree::Store.find_or_create_by(code: 'b2b') do |store|
      store.name = 'Bates Embroidery - B2B Wholesale'
      store.url = 'b2b.batesembroidery.com'
      store.mail_from_address = 'wholesale@batesembroidery.com'
      store.default_currency = 'USD'
      store.default = false
    end
  end

  def current_store_is_b2b?
    @current_store&.code == 'b2b'
  end

  def current_store_is_retail?
    @current_store&.code == 'retail'
  end

  def require_b2b_access
    return unless current_store_is_b2b?
    
    unless spree_current_user && spree_current_user.has_spree_role?('b2b_customer')
      redirect_to spree.login_path, alert: 'B2B access requires approved wholesale account.'
    end
  end

  def hide_pricing_for_unapproved_b2b
    return false unless current_store_is_b2b?
    return false if spree_current_user && spree_current_user.has_spree_role?('b2b_customer')
    
    true
  end

  helper_method :current_store_is_b2b?, :current_store_is_retail?, :hide_pricing_for_unapproved_b2b

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :company_name, :tax_id, :website, :expected_volume, :sanmar_customer_number, :ss_activewear_customer_number])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :company_name, :tax_id, :website, :expected_volume, :sanmar_customer_number, :ss_activewear_customer_number])
  end
end
