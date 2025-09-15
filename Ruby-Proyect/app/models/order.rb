class Order < ApplicationRecord
  belongs_to :user
  belongs_to :carrito, optional: true
  belongs_to :coupon, optional: true
  has_many :order_items, dependent: :destroy
  has_many :payments
  after_save :update_total

  enum :status, {
    pendiente: 0,
    pagado: 1,
    en_preparacion: 2,
    enviado: 3,
    entregado: 4,
    cancelado: 5
  }

  scope :by_user, ->(user) { where(user_id: user.id) }

  validates :code, presence: true, uniqueness: true
  validates :total, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_validation :generate_unique_code, on: :create

  after_create_commit -> {
    broadcast_append_to "employee_orders",
      target: "employee-orders-list",
      partial: "dashboard/orders/order",
      locals: { order: self }
  }

  after_update_commit -> {
    broadcast_replace_to "employee_orders",
      partial: "dashboard/orders/order",
      locals: { order: self }
  }

  after_destroy_commit -> {
    broadcast_remove_to "employee_orders"
  }

  # Use código en la URL en vez de id
  def to_param
    code
  end

  # Calcula subtotal sin descuento
  def subtotal
    order_items.sum("quantity * price")
  end

  # Calcula descuento del cupón si aplica
  def coupon_discount
    return 0 unless coupon.present?

    case coupon.tipo_descuento
    when "porcentaje"
      (subtotal * coupon.valor / 100.0).round(2)
    when "fijo"
      coupon.valor
    else
      0
    end
  end

  # Calcula total final (subtotal - descuento)
  def calculate_total
    [ subtotal - coupon_discount, 0 ].max
  end

  # Método para aplicar y guardar el total final
  def apply_coupon!
    self.total = calculate_total
    save!
    self
  end


  private

  def update_total
    update_column(:total, calculate_total)
  end

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
