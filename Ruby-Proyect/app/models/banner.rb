class Banner < ApplicationRecord
  has_one_attached :imagen do |attachable|
    attachable.variant :desktop, resize_to_fill: [ 1200, 400 ], preprocessed: true
    attachable.variant :tablet, resize_to_fill: [ 992, 330 ], preprocessed: true
    attachable.variant :mobile, resize_to_fill: [ 768, 256 ], preprocessed: true
  end

  # Método para obtener la URL de la imagen
  def imagen_url
    return nil unless imagen.attached?
    Rails.application.routes.url_helpers.rails_blob_path(imagen, only_path: true)
  end

  # Banner optimizado para desktop (WebP con alta calidad)
  def imagen_resized
    return unless imagen.attached?
    imagen.variant(
      resize_to_fill: [ 1200, 400 ],
      format: :webp,
      saver: { quality: 90, strip: true }
    ).processed
  end

  # Banner optimizado para móvil
  def imagen_mobile
    return unless imagen.attached?
    imagen.variant(
      resize_to_fill: [ 768, 256 ],
      format: :webp,
      saver: { quality: 85, strip: true }
    ).processed
  end

  # Banner para tablet
  def imagen_tablet
    return unless imagen.attached?
    imagen.variant(
      resize_to_fill: [ 992, 330 ],
      format: :webp,
      saver: { quality: 88, strip: true }
    ).processed
  end
end
