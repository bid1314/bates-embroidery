class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :customize, :save_customization]
  
  def index
    @products = Product.active
    @products = @products.by_supplier(params[:supplier]) if params[:supplier].present?
    @products = @products.where("name ILIKE ?", "%#{params[:search]}%") if params[:search].present?
    @products = @products.limit(20) # Simple limit for now
  end

  def show
    @customization = current_user&.customizations&.build
  end

  def save_customization
    @customization = current_user.customizations.build(customization_params)
    @customization.product = @product
    
    if @customization.save
      redirect_to @product, notice: 'Customization saved successfully!'
    else
      redirect_to @product, alert: 'Failed to save customization. Please try again.'
    end
  end
  
  def customize
    # Render customization interface
  end
  
  def save_customization
    if user_signed_in?
      @customization = current_user.customizations.build(customization_params)
      @customization.product = @product
      
      if @customization.save
        redirect_to @product, notice: 'Customization saved successfully!'
      else
        render :show, alert: 'Failed to save customization.'
      end
    else
      redirect_to new_user_session_path, alert: 'Please sign in to save customizations.'
    end
  end
  
  private
  
  def set_product
    @product = Product.find(params[:id])
  end
  
  def customization_params
    params.require(:customization).permit(:design_data, :ai_estimation, :status)
  end
end
