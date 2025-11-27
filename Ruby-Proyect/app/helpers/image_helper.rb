# frozen_string_literal: true

module ImageHelper
  # Genera un tag de imagen optimizado con lazy loading y srcset responsivo
  #
  # Uso:
  #   <%= optimized_image_tag(@product, :imagen, size: :medium, alt: @product.nombre) %>
  #
  def optimized_image_tag(record, attachment_name, options = {})
    return nil unless record.send(attachment_name).attached?

    size = options.delete(:size) || :medium
    lazy = options.fetch(:lazy, true)

    # Configurar lazy loading
    options[:loading] = "lazy" if lazy
    options[:decoding] = "async"

    # Agregar clases para optimización
    options[:class] = [ options[:class], "img-optimized" ].compact.join(" ")

    # Determinar variante según el tamaño
    variant = case size
    when :thumb, :thumbnail
      record.respond_to?(:imagen_thumbnail) ? record.imagen_thumbnail : record.send(attachment_name)
    when :medium
      record.respond_to?(:imagen_resized) ? record.imagen_resized : record.send(attachment_name)
    when :large
      record.respond_to?(:imagen_resized2) ? record.imagen_resized2 : record.send(attachment_name)
    else
      record.send(attachment_name)
    end

    image_tag(variant, options)
  rescue => e
    Rails.logger.error "Error generando imagen: #{e.message}"
    nil
  end

  # Genera un background-image CSS optimizado
  #
  # Uso:
  #   <div <%= optimized_background_style(@banner, :imagen) %>>
  #
  def optimized_background_style(record, attachment_name, size: :medium)
    return "" unless record.send(attachment_name).attached?

    variant = case size
    when :thumb
      record.respond_to?(:imagen_thumbnail) ? record.imagen_thumbnail : record.send(attachment_name)
    when :mobile
      record.respond_to?(:imagen_mobile) ? record.imagen_mobile : record.send(attachment_name)
    when :tablet
      record.respond_to?(:imagen_tablet) ? record.imagen_tablet : record.send(attachment_name)
    else
      record.respond_to?(:imagen_resized) ? record.imagen_resized : record.send(attachment_name)
    end

    url = url_for(variant)
    "style=\"background-image: url('#{url}');\"".html_safe
  rescue => e
    Rails.logger.error "Error generando background: #{e.message}"
    "".html_safe
  end

  # Genera un srcset para imágenes responsivas
  #
  # Uso:
  #   <%= responsive_image_tag(@product, :imagen, alt: @product.nombre) %>
  #
  def responsive_image_tag(record, attachment_name, options = {})
    return nil unless record.send(attachment_name).attached?

    lazy = options.fetch(:lazy, true)
    options[:loading] = "lazy" if lazy
    options[:decoding] = "async"

    # Construir srcset para diferentes tamaños
    srcset_parts = []

    if record.respond_to?(:imagen_thumbnail)
      srcset_parts << "#{url_for(record.imagen_thumbnail)} 150w"
    end

    if record.respond_to?(:imagen_resized)
      srcset_parts << "#{url_for(record.imagen_resized)} 300w"
    end

    if record.respond_to?(:imagen_resized2)
      srcset_parts << "#{url_for(record.imagen_resized2)} 600w"
    end

    options[:srcset] = srcset_parts.join(", ") unless srcset_parts.empty?
    options[:sizes] = options[:sizes] || "(max-width: 640px) 150px, (max-width: 1024px) 300px, 600px"

    # Usar la imagen mediana como src por defecto
    src_variant = if record.respond_to?(:imagen_resized)
      record.imagen_resized
    else
      record.send(attachment_name)
    end

    image_tag(src_variant, options)
  rescue => e
    Rails.logger.error "Error generando imagen responsiva: #{e.message}"
    nil
  end

  # Precarga crítica de imágenes (para LCP - Largest Contentful Paint)
  #
  # Uso en layout:
  #   <%= preload_critical_image(@hero_banner, :imagen) %>
  #
  def preload_critical_image(record, attachment_name)
    return nil unless record.send(attachment_name).attached?

    variant = record.respond_to?(:imagen_resized) ? record.imagen_resized : record.send(attachment_name)
    url = url_for(variant)

    tag.link(rel: "preload", as: "image", href: url, type: "image/webp")
  rescue => e
    Rails.logger.error "Error en preload crítico: #{e.message}"
    nil
  end
end
