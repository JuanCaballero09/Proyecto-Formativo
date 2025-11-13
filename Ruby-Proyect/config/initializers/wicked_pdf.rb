# config/initializers/wicked_pdf.rb

# Intentar detectar automáticamente la ruta de wkhtmltopdf
detected_path = `which wkhtmltopdf`.strip

# Si no se detecta, usar rutas por defecto dependiendo del sistema
if detected_path.empty?
  detected_path = case RUBY_PLATFORM
  when /darwin/
    "/usr/local/bin/wkhtmltopdf" # macOS (Homebrew)
  when /linux/
    "/home/juanes/.rvm/gems/ruby-3.4.6/bin/wkhtmltopdf\n"       # Ubuntu/Debian
  else
    nil
  end
end

# Configurar WickedPdf
WickedPdf.configure do |config|
  config.exe_path = detected_path
  config.enable_local_file_access = true
end

# Mostrar advertencia si no se encontró
unless File.exist?(detected_path.to_s)
  Rails.logger.warn "[WickedPdf] ⚠️ No se encontró wkhtmltopdf en el sistema. Instálalo con:\n" \
                    "  sudo apt install wkhtmltopdf  # (Linux)\n" \
                    "  brew install wkhtmltopdf      # (macOS)"
end