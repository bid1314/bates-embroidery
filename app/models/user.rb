class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Spree integration
  include Spree::UserMethods if defined?(Spree::UserMethods)

  # Associations
  has_many :customizations, dependent: :destroy
  has_many :orders, dependent: :destroy
  
  # Enums
  enum role: { customer: 0, b2b_customer: 1, admin: 2 }
  
  # Validations
  validates :role, presence: true
  
  # Callbacks
  after_initialize :set_default_role, if: :new_record?
  
  # Spree role methods
  def has_spree_role?(role_name)
    case role_name.to_s
    when 'admin'
      admin?
    when 'b2b_customer'
      b2b_customer?
    else
      customer?
    end
  end
  
  private
  
  def set_default_role
    self.role ||= :customer
  end
end
