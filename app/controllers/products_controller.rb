class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :customize, :save_customization]
  
  def index
    @products = Spree::Product.available.includes(:images)
    @products = @products.where("name ILIKE ?", "%#{params[:search]}%") if params[:search].present?
    @products = @products.page(params[:page]).per(12)
  end

  def show
    @variants = @product.variants.includes(:images)
    @customization = current_user&.customizations&.find_by(product: @product) || Customization.new
  end
  
  def customize
    @customization = current_user&.customizations&.find_by(product: @product) || Customization.new
    render layout: 'customization'
  end
  
  def save_customization
    if user_signed_in?
      @customization = current_user.customizations.find_or_initialize_by(product: @product)
      
      if @customization.update(customization_params)
        render json: { success: true, message: 'Customization saved successfully' }
      else
        render json: { success: false, errors: @customization.errors.full_messages }
      end
    else
      render json: { success: false, message: 'Please sign in to save customizations' }
    end
  end
  
  private
  
  def set_product
    @product = Spree::Product.friendly.find(params[:id])
  end
  
  def customization_params
    params.require(:customization).permit(:design_data, :preview_image, :notes, :ai_estimation)
  end
end
