class Combo < Product
  has_many :combo_items, foreign_key: :combo_id, dependent: :destroy, inverse_of: :combo
  has_many :componentes, through: :combo_items, source: :product

  accepts_nested_attributes_for :combo_items, allow_destroy: true

  validates :precio, numericality: { greater_than_or_equal_to: 0 }
  validate :must_have_components

  def self.model_name
    Product.model_name
  end

  def items_detalle
    combo_items.includes(:product).map { |ci| "#{ci.cantidad} x #{ci.product.nombre}" }
  end

  def total_componentes
    combo_items.sum(:cantidad)
  end

  private

  def must_have_components
    if combo_items.empty? || combo_items.all?(&:marked_for_destruction?)
      errors.add(:base, "Un combo debe tener al menos un componente")
    end
  end
end
