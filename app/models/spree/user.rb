module Spree
  class User < Spree::Base
    include UserAddress
    include UserMethods
    include UserPaymentSource

    devise :database_authenticatable, :registerable, :recoverable,
           :rememberable, :trackable, :validatable, :encryptable

    belongs_to :ship_address, class_name: 'Spree::Address', optional: true
    belongs_to :bill_address, class_name: 'Spree::Address', optional: true

    has_many :orders, foreign_key: :user_id, class_name: 'Spree::Order'
    has_many :role_users, foreign_key: :user_id, class_name: 'Spree::RoleUser'
    has_many :roles, through: :role_users, class_name: 'Spree::Role'

    has_many :user_stock_locations, foreign_key: :user_id, class_name: 'Spree::UserStockLocation'
    has_many :stock_locations, through: :user_locations, class_name: 'Spree::StockLocation'

    has_many :credit_cards, class_name: 'Spree::CreditCard'

    before_validation :set_login

    users_table_name = User.table_name
    roles_table_name = Spree::Role.table_name

    scope :admin, -> { includes(:roles).where("#{roles_table_name}.name" => 'admin') }

    def self.admin_created?
      User.admin.exists?
    end

    def admin?
      has_spree_role?('admin')
    end

    def has_spree_role?(role_in_question)
      roles.where(name: role_in_question.to_s).any?
    end

    def last_incomplete_spree_order(store = nil, options = {})
      orders.where(completed_at: nil, store: store || Spree::Store.current).
        includes(options[:includes]).
        order('created_at DESC').
        first
    end

    def total_available_store_credit
      store_credits.reload.to_a.sum(&:amount_remaining)
    end

    private

    def set_login
      # for now force login to be same as email, eventually we will make this configurable, etc.
      self.login ||= email if email
    end

    def password_required?
      !persisted? || password.present? || password_confirmation.present?
    end
  end
end