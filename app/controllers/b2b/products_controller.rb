class B2b::ProductsController < B2bController
  before_action :set_product, only: [:show, :customize, :save_customization]

  def index
    @products = Spree::Product.available.includes(:images, :variants)
    @products = @products.where("name ILIKE ?", "%#{params[:search]}%") if params[:search].present?
    @products = @products.page(params[:page]).per(12)
  end

  def show
    @variants = @product.variants.includes(:images, :option_values)
    @customization = Customization.new
    @show_pricing = user_signed_in? && current_user.b2b_customer?
  end

  def customize
    # Render the product customization page
    render :customize
  end

  def save_customization
    @customization = current_user.customizations.build(customization_params)
    @customization.product = @product

    if @customization.save
      render json: { success: true, customization_id: @customization.id }
    else
      render json: { success: false, errors: @customization.errors.full_messages }
    end
  end

  private

  def set_product
    @product = Spree::Product.friendly.find(params[:id])
  end

  def customization_params
    params.require(:customization).permit(:design_data, :stitch_count, :estimated_cost, :notes)
  end
end