# frozen_string_literal: true

# config/initializers/active_storage.rb
# Configuración de Active Storage para optimizar rendimiento

# Configuración de procesamiento de imágenes
Rails.application.config.active_storage.variant_processor = :vips

# Configurar análisis automático de imágenes
Rails.application.config.active_storage.analyzers = [
  ActiveStorage::Analyzer::ImageAnalyzer::Vips,
  ActiveStorage::Analyzer::ImageAnalyzer::ImageMagick,
  ActiveStorage::Analyzer::VideoAnalyzer
]

# Limitar tamaño de archivos (opcional)
# Rails.application.config.active_storage.content_types_allowed_inline = %w[
#   image/png
#   image/gif
#   image/jpg
#   image/jpeg
#   image/webp
# ]
