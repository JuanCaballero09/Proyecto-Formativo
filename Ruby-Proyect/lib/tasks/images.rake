# frozen_string_literal: true

namespace :images do
  desc "Precargar todas las variantes de imágenes (Productos, Grupos, Banners) en formato WebP"
  task preload: :environment do
    puts "🔄 Precargando variantes optimizadas (WebP)..."

    total = 0
    errors = 0

    [
      { model: Product, field: :imagen, name: "Productos", variants: [ :imagen_thumbnail, :imagen_resized, :imagen_resized2 ] },
      { model: Grupo, field: :imagen, name: "Grupos", variants: [ :imagen_thumbnail, :imagen_resized ] },
      { model: Banner, field: :imagen, name: "Banners", variants: [ :imagen_mobile, :imagen_tablet, :imagen_resized ] }
    ].each do |config|
      puts "\n➡ Procesando #{config[:name]}..."
      count = 0

      config[:model].find_each do |record|
        next unless record.send(config[:field]).attached?

        begin
          # Generar todas las variantes del modelo
          config[:variants].each do |variant_method|
            record.send(variant_method) if record.respond_to?(variant_method)
          end
          count += 1
          print "."
        rescue => e
          errors += 1
          puts "\n❌ Error en #{config[:name]} ##{record.id}: #{e.message}"
        end
      end

      total += count
      puts "\n✅ #{count} #{config[:name]} procesadas"
    end

    puts "\n" + "="*50
    puts "✅ Completado: #{total} registros procesados"
    puts "⚠️  Errores: #{errors}" if errors > 0
    puts "\n💡 Tip: Las imágenes están ahora en formato WebP (más ligeras)"
  end

  desc "Limpiar variantes de imágenes generadas"
  task clean_variants: :environment do
    puts "🧹 Limpiando variantes de Active Storage..."

    # Esta tarea solo funciona si usas ActiveStorage::Variant::Record (Rails 7+)
    if defined?(ActiveStorage::VariantRecord)
      count = ActiveStorage::VariantRecord.count
      ActiveStorage::VariantRecord.destroy_all
      puts "✅ #{count} variantes eliminadas"
    else
      puts "⚠️  Esta funcionalidad requiere Rails 7+"
    end
  end

  desc "Estadísticas de imágenes y variantes"
  task stats: :environment do
    puts "📊 Estadísticas de Active Storage\n"
    puts "="*50

    [
      { model: Product, field: :imagen, name: "Productos" },
      { model: Grupo, field: :imagen, name: "Grupos" },
      { model: Banner, field: :imagen, name: "Banners" }
    ].each do |config|
      total = config[:model].count
      with_image = config[:model].joins("#{config[:field]}_attachment": :blob).distinct.count

      puts "#{config[:name]}:"
      puts "  Total: #{total}"
      puts "  Con imagen: #{with_image}"
      puts "  Sin imagen: #{total - with_image}"
      puts ""
    end

    blobs = ActiveStorage::Blob.count
    attachments = ActiveStorage::Attachment.count

    puts "Total Blobs: #{blobs}"
    puts "Total Attachments: #{attachments}"

    if defined?(ActiveStorage::VariantRecord)
      variants = ActiveStorage::VariantRecord.count
      puts "Total Variants: #{variants}"
    end

    puts "="*50
  end
end
