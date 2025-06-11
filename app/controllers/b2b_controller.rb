class B2bController < ApplicationController
  before_action :set_b2b_store
  before_action :authenticate_b2b_user!, except: [:index, :login, :register]
  layout 'b2b'

  private

  def set_b2b_store
    @current_store = Spree::Store.find_by(code: 'b2b') || Spree::Store.default
    Spree::Store.current = @current_store
  end

  def authenticate_b2b_user!
    unless user_signed_in? && current_user.b2b_customer?
      redirect_to b2b_login_path, alert: 'Please log in with your B2B account to view pricing.'
    end
  end
end