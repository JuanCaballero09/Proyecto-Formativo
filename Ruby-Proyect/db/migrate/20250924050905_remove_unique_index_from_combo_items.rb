class RemoveUniqueIndexFromComboItems < ActiveRecord::Migration[8.0]
  def change
    # Eliminar el índice único existente
    remove_index :combo_items, [ :combo_id, :product_id ], if_exists: true

    # Agregar un índice no único para mantener la performance de consultas
    add_index :combo_items, [ :combo_id, :product_id ], unique: false
  end
end
