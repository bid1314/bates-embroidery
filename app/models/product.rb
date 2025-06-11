class Product < ApplicationRecord
  # Associations
  has_many :customizations, dependent: :destroy
  has_many_attached :images
  
  # Validations
  validates :name, presence: true
  validates :sku, presence: true, uniqueness: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  
  # Scopes
  scope :active, -> { where(active: true) }
  scope :by_supplier, ->(supplier_type) { where(supplier_type: supplier_type) }
  
  # Enums
  enum supplier_type: { sanmar: 0, ss_activewear: 1, custom: 2 }
  
  # Callbacks
  after_initialize :set_defaults, if: :new_record?
  
  # Methods
  def display_price
    "$#{price.to_f}"
  end
  
  def customizable?
    true # All products are customizable in this platform
  end
  
  private
  
  def set_defaults
    self.active = true if active.nil?
    self.supplier_type ||= :custom
  end
end
