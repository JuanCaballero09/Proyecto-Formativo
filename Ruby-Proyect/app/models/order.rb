class Order < ApplicationRecord
  belongs_to :user
  belongs_to :carrito, optional: true
  has_many :order_items, dependent: :destroy

  enum :status, {
    pendiente: 0, 
    pagado: 1, 
    en_preparacion: 2, 
    enviado: 3, 
    entregado: 4,
    cancelada: 5
  }

  scope :by_user, ->(user) { where(user_id: user.id) }

  validates :code, presence: true, uniqueness: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_validation :generate_unique_code, on: :create

  # Use código en la URL en vez de id
  def to_param
    code
  end

  def total_price
    order_items.sum("quantity * price")
  end

  private

  def generate_unique_code
    return if code.present?

    loop do
      # Formato: ORD-20250801-A1B2C3
      candidate = "ORD-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.alphanumeric(6).upcase}"
      unless Order.exists?(code: candidate)
        self.code = candidate
        break
      end
    end
  end
end
