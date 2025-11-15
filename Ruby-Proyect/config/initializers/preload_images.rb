# config/initializers/preload_images.rb

Rails.application.config.after_initialize do
  Thread.new do
    Rails.logger.info "🔄 Precargando imágenes de Productos, Grupos y Banners..."

    MODELS = [
      { klass: Product, attach: :imagen },
      { klass: Grupo, attach: :imagen },
      { klass: Banner, attach: :imagen }
    ]

    MODELS.each do |config|
      klass  = config[:klass]
      attach = config[:attach]

      Rails.logger.info "➡ Precargando #{klass.name}..."

      begin
        klass.includes("#{attach}_attachment": :blob).find_each do |record|
          next unless record.send(attach).attached?

          begin
            # 1. Precargar imagen original
            record.send(attach).blob.open { |f| f.read }
            Rails.logger.info "✔ #{klass.name} ##{record.id} → blob precargado"

            # 2. Precargar variante estándar
            begin
              variant = record.send(attach).variant(resize_to_limit: [ 600, 600 ]).processed
              variant.service.download(variant.key)
              Rails.logger.info "   ✔ Variante precargada (#{klass.name} ##{record.id})"
            rescue => e
              Rails.logger.warn "   ⚠ No se pudo generar variante en #{klass.name} ##{record.id}: #{e.message}"
            end

          rescue => e
            Rails.logger.error "❌ Error precargando #{klass.name} ##{record.id}: #{e.message}"
          end
        end

        Rails.logger.info "✔ Finalizado #{klass.name}"

      rescue => e
        Rails.logger.error "🔥 Error general cargando #{klass.name}: #{e.message}"
      end
    end

    Rails.logger.info "✅ TODAS las imágenes del sistema están precargadas."
  end
end
