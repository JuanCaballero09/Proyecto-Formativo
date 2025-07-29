class BusquedaController < ApplicationController
  def index
    if params[:q].present?
      raw_query = params[:q].downcase.strip
      query = I18n.transliterate(raw_query)
      terms = query.split

      # Coincidencia exacta (ya sin tildes)
      exacto = Product.all.find do |product|
        I18n.transliterate(product.nombre.downcase.strip) == query
      end

      # Coincidencia por partes (elimina tildes en SQL con ILIKE no es posible directamente)
      @grupos = Grupo.all.select do |g|
        normalizado = I18n.transliterate(g.nombre.downcase.strip)
        terms.all? { |t| normalizado.include?(t) }
      end.sort_by(&:id)

      @productos = Product.all.select do |p|
        normalizado = I18n.transliterate(p.nombre.downcase.strip)
        terms.all? { |t| normalizado.include?(t) }
      end.sort_by(&:id)

      # Redirigir si hay coincidencia exacta
      if exacto.present? && @productos.size == 1
        redirect_to grupo_producto_path(exacto.grupo, exacto) and return
      end
    else
      @grupos = []
      @productos = []
    end
  end
end
