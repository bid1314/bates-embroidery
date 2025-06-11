class HomeController < ApplicationController
  def index
    @featured_products = Product.active.limit(6)
    @stores = Store.active
  end
end
