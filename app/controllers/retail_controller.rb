class RetailController < ApplicationController
  before_action :set_retail_store
  layout 'retail'

  private

  def set_retail_store
    @current_store = Spree::Store.find_by(code: 'retail') || Spree::Store.default
    Spree::Store.current = @current_store
  end
end