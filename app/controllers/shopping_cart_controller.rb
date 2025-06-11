class ShoppingCartController < ApplicationController
  before_action :authenticate_user!, except: [:show, :add_item, :remove_item, :update_quantity]
  before_action :ensure_current_order, only: [:add_item, :remove_item, :update_quantity]

  def show
    @order = current_order || Spree::Order.new
    @line_items = @order.line_items.includes(:variant)
  end

  def add_item
    variant = Spree::Variant.find(params[:variant_id])
    quantity = params[:quantity].to_i
    
    @order.contents.add(variant, quantity, {
      customization_data: params[:customization_data]
    })
    
    if @order.save
      render json: { 
        success: true, 
        message: 'Item added to cart',
        cart_count: @order.item_count,
        cart_total: @order.display_total.to_s
      }
    else
      render json: { 
        success: false, 
        message: @order.errors.full_messages.join(', ')
      }
    end
  end

  def remove_item
    line_item = @order.line_items.find(params[:line_item_id])
    @order.contents.remove(line_item.variant, line_item.quantity)
    
    if @order.save
      render json: { 
        success: true, 
        message: 'Item removed from cart',
        cart_count: @order.item_count,
        cart_total: @order.display_total.to_s
      }
    else
      render json: { 
        success: false, 
        message: @order.errors.full_messages.join(', ')
      }
    end
  end

  def update_quantity
    line_item = @order.line_items.find(params[:line_item_id])
    new_quantity = params[:quantity].to_i
    
    if new_quantity > 0
      @order.contents.add(line_item.variant, new_quantity - line_item.quantity)
    else
      @order.contents.remove(line_item.variant, line_item.quantity)
    end
    
    if @order.save
      render json: { 
        success: true, 
        message: 'Cart updated',
        cart_count: @order.item_count,
        cart_total: @order.display_total.to_s
      }
    else
      render json: { 
        success: false, 
        message: @order.errors.full_messages.join(', ')
      }
    end
  end

  def clear
    if current_order
      current_order.empty!
      session[:order_id] = nil
    end
    
    render json: { 
      success: true, 
      message: 'Cart cleared',
      cart_count: 0,
      cart_total: '$0.00'
    }
  end

  private

  def ensure_current_order
    @order = current_order || create_order
  end

  def current_order
    return nil unless session[:order_id]
    @current_order ||= Spree::Order.find_by(id: session[:order_id], completed_at: nil)
  end

  def create_order
    order = Spree::Order.create!(
      user: current_user,
      store: current_store,
      currency: current_store.default_currency
    )
    session[:order_id] = order.id
    order
  end
end