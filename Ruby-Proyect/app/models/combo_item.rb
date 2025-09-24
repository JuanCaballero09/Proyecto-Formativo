class ComboItem < ApplicationRecord
  belongs_to :combo, class_name: "Combo"
  belongs_to :product

  validates :cantidad, numericality: { only_integer: true, greater_than: 0 }
end
