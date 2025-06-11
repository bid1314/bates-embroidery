class Store < ApplicationRecord
  # Associations
  has_many :orders, dependent: :destroy
  
  # Validations
  validates :name, presence: true
  validates :subdomain, presence: true, uniqueness: true
  validates :domain, presence: true
  
  # Scopes
  scope :active, -> { where(active: true) }
  
  # Serialization
  serialize :settings, coder: JSON
  
  # Callbacks
  after_initialize :set_defaults, if: :new_record?
  
  private
  
  def set_defaults
    self.active = true if active.nil?
    self.settings ||= {}
  end
end
