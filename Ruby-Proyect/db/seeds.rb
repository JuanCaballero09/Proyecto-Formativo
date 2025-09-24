# ============================================================================
# 🌱 SEEDS - RESTAURANTE ARTESANAL
# ============================================================================

puts "🗑️  Limpiando base de datos..."

# Destruir en orden correcto para evitar problemas de dependencias
begin
  puts "Eliminando datos dependientes..."

  # Primero eliminar las dependencias más profundas
  Payment.destroy_all if defined?(Payment)
  ComboItem.destroy_all if defined?(ComboItem)
  OrderItem.destroy_all if defined?(OrderItem)
  CarritoItem.destroy_all if defined?(CarritoItem)
  CouponUsage.destroy_all if defined?(CouponUsage)
  IngredienteProducto.destroy_all

  # Luego las entidades principales
  Order.destroy_all if defined?(Order)
  Carrito.destroy_all if defined?(Carrito)
  Combo.destroy_all if defined?(Combo)
  Coupon.destroy_all if defined?(Coupon)
  Banner.destroy_all if defined?(Banner)
  Product.destroy_all
  Ingrediente.destroy_all
  Grupo.destroy_all
  User.destroy_all

  puts "✅ Datos eliminados correctamente"
rescue => e
  puts "⚠️ Error durante la limpieza: #{e.message}"
  puts "Intentando limpieza alternativa..."

  # Método alternativo: desactivar temporalmente las restricciones
  ActiveRecord::Base.connection.disable_referential_integrity do
    [ Payment, ComboItem, OrderItem, CarritoItem, CouponUsage, IngredienteProducto,
     Order, Carrito, Combo, Coupon, Banner, Product, Ingrediente, Grupo, User ].each do |model|
      begin
        model.destroy_all if defined?(model)
      rescue => model_error
        puts "⚠️  Error al limpiar #{model}: #{model_error.message}"
      end
    end
  end
end

# Reset secuencias de IDs
puts "🔄 Reseteando secuencias..."
%w[grupos users products ingredientes coupons combos banners orders order_items carritos carrito_items coupon_usages payments].each do |table|
  begin
    ActiveRecord::Base.connection.reset_pk_sequence!(table)
  rescue => e
    puts "⚠️  No se pudo resetear secuencia de #{table}: #{e.message}"
  end
end

puts "✅ Base de datos limpia\n"

# ============================================================================
# 👥 USUARIOS
# ============================================================================

puts "👥 Creando usuarios..."

# Admin principal
User.create!(
  email: "admin@admin.com",
  password: "rasdix-jePjor-kohsy6",
  nombre: "Super",
  apellido: "Admin",
  telefono: "3001234567",
  rol: :admin,
  confirmed_at: Time.current,
  authentication_token: SecureRandom.hex(20)
)

# Usuarios de prueba
clientes = []
3.times do |i|
  cliente = User.create!(
    email: "cliente#{i+1}@test.com",
    password: "123456789",
    nombre: "Cliente",
    apellido: "Número #{i+1}",
    telefono: "300123456#{i}",
    rol: :cliente,
    confirmed_at: Time.current,
    authentication_token: SecureRandom.hex(20)
  )
  clientes << cliente
end

puts "✅ Usuarios creados: #{User.count}\n"

# ============================================================================
# 🍽️ GRUPOS DE PRODUCTOS
# ============================================================================

puts "🍽️ Creando grupos de productos..."

grupos_data = [
  {
    nombre: "🍔 Hamburguesas",
    descripcion: "Jugosas hamburguesas artesanales con ingredientes frescos y pan recién horneado"
  },
  {
    nombre: "🍟 Salchipapas",
    descripcion: "Papas doradas con variedad de carnes y salsas especiales de la casa"
  },
  {
    nombre: "🍕 Pizzas",
    descripcion: "Pizzas al horno de leña con masa artesanal y ingredientes premium"
  },
  {
    nombre: "🥤 Bebidas",
    descripcion: "Refrescantes bebidas naturales y gaseosas para acompañar tu comida"
  },
  {
    nombre: "🍰 Postres",
    descripcion: "Deliciosos postres caseros para cerrar con broche de oro"
  }
]

grupos = {}
grupos_data.each do |data|
  grupo = Grupo.create!(data)
  grupos[data[:nombre].split.last] = grupo # Guarda sin emoji para fácil acceso
end

puts "✅ Grupos creados: #{Grupo.count}\n"

# ============================================================================
# 🥬 INGREDIENTES
# ============================================================================

puts "🥬 Creando ingredientes..."

ingredientes_data = [
  # Proteínas
  "Carne de res premium", "Pollo desmechado", "Salchicha premium", "Chorizo artesanal",
  "Tocineta ahumada", "Jamón serrano", "Pepperoni", "Salami italiano", "Huevo",

  # Quesos
  "Queso mozzarella", "Queso cheddar", "Queso parmesano", "Queso azul", "Queso de cabra",

  # Vegetales frescos
  "Lechuga fresca", "Tomate maduro", "Cebolla blanca", "Cebolla caramelizada", "Cebolla morada",
  "Maíz tierno", "Pepinillos encurtidos", "Aguacate", "Pimentón rojo", "Champiñones",
  "Rúcula", "Espinaca baby", "Jalapeños",

  # Panes y bases
  "Pan de hamburguesa artesanal", "Pan de perro caliente", "Masa de pizza artesanal",
  "Arepa de maíz", "Tortilla de harina", "Tortilla de maíz",

  # Papas y acompañantes
  "Papas a la francesa", "Papas rústicas", "Papas ripio",

  # Salsas y condimentos
  "Salsa rosada casera", "Salsa tártara", "Salsa BBQ ahumada", "Salsa de tomate",
  "Mayonesa de ajo", "Guacamole", "Pesto casero", "Salsa picante", "Mostaza de miel",

  # Frutas
  "Piña fresca", "Tomate cherry",

  # Especias y hierbas
  "Orégano fresco", "Albahaca", "Cilantro", "Perejil", "Ajo triturado"
]

ingredientes = {}
ingredientes_data.each do |nombre|
  ingredientes[nombre] = Ingrediente.create!(nombre: nombre)
end

puts "✅ Ingredientes creados: #{Ingrediente.count}\n"

# ============================================================================
# 🍔 PRODUCTOS
# ============================================================================

puts "🍔 Creando productos..."

# Rutas de imágenes
imagenes = {
  hamburguesas: Rails.root.join("db", "seeds", "hamburguesas.png"),
  salchipapas: Rails.root.join("db", "seeds", "Salchipapa.jpg"),
  pizzas: Rails.root.join("db", "seeds", "pizzas.jpg")
}

# === HAMBURGUESAS ===
hamburguesas_data = [
  {
    nombre: "Clásica Deluxe",
    precio: 16500,
    descripcion: "Nuestra hamburguesa insignia con carne premium, quesos selectos y vegetales frescos",
    ingredientes: [ "Carne de res premium", "Queso cheddar", "Lechuga fresca", "Tomate maduro", "Pan de hamburguesa artesanal", "Salsa rosada casera" ]
  },
  {
    nombre: "BBQ Ahumada",
    precio: 18000,
    descripcion: "Explosión de sabor ahumado con tocineta crujiente y cebolla caramelizada",
    ingredientes: [ "Carne de res premium", "Tocineta ahumada", "Queso mozzarella", "Cebolla caramelizada", "Pan de hamburguesa artesanal", "Salsa BBQ ahumada" ]
  },
  {
    nombre: "Pollo Gourmet",
    precio: 17000,
    descripcion: "Jugoso pollo desmechado con guacamole casero y vegetales frescos",
    ingredientes: [ "Pollo desmechado", "Lechuga fresca", "Tomate maduro", "Pan de hamburguesa artesanal", "Guacamole", "Aguacate" ]
  },
  {
    nombre: "Mexicana Picante",
    precio: 17500,
    descripcion: "Sabor azteca con ajo, guacamole y un toque picante que despierta tus sentidos",
    ingredientes: [ "Carne de res premium", "Ajo triturado", "Guacamole", "Jalapeños", "Pan de hamburguesa artesanal", "Salsa picante" ]
  },
  {
    nombre: "Doble Tentación",
    precio: 22000,
    descripcion: "Para los más hambrientos: doble carne, doble queso, doble satisfacción",
    ingredientes: [ "Carne de res premium", "Carne de res premium", "Queso cheddar", "Queso mozzarella", "Pan de hamburguesa artesanal", "Salsa rosada casera" ]
  },
  {
    nombre: "Hawaiana Tropical",
    precio: 18500,
    descripcion: "Fusión perfecta de jamón serrano, piña fresca y queso derretido",
    ingredientes: [ "Carne de res premium", "Jamón serrano", "Piña fresca", "Queso mozzarella", "Pan de hamburguesa artesanal" ]
  },
  {
    nombre: "Criolla Tradicional",
    precio: 17000,
    descripcion: "Sabor casero con huevo, queso y el toque criollo que te recuerda a casa",
    ingredientes: [ "Carne de res premium", "Huevo", "Queso mozzarella", "Cebolla blanca", "Pan de hamburguesa artesanal" ]
  },
  {
    nombre: "Veggie Deluxe",
    precio: 15500,
    descripcion: "Opción vegetariana llena de sabor con champiñones, queso de cabra y rúcula",
    ingredientes: [ "Champiñones", "Queso de cabra", "Rúcula", "Tomate maduro", "Pan de hamburguesa artesanal", "Pesto casero" ]
  }
]

hamburguesas_data.each_with_index do |data, index|
  begin
    producto = Product.create!(
      nombre: data[:nombre],
      precio: data[:precio],
      descripcion: data[:descripcion],
      disponible: true,
      grupo: grupos["Hamburguesas"]
    )

    data[:ingredientes].each do |ing_nombre|
      if ingredientes[ing_nombre]
        producto.ingredientes << ingredientes[ing_nombre]
      else
        puts "  ⚠️  Ingrediente no encontrado: #{ing_nombre}"
      end
    end

    if File.exist?(imagenes[:hamburguesas])
      producto.imagen.attach(
        io: File.open(imagenes[:hamburguesas]),
        filename: "hamburguesas.png",
        content_type: "image/png"
      )
    end
  rescue => e
    puts "❌ Error creando hamburguesa #{data[:nombre]}: #{e.message}"
    puts "   Detalles: #{e.record.errors.full_messages.join(', ')}" if e.respond_to?(:record) && e.record.errors.any?
  end
end

# === SALCHIPAPAS ===
salchipapas_data = [
  {
    nombre: "Clásica Original",
    precio: 12500,
    descripcion: "La receta tradicional que nunca pasa de moda",
    ingredientes: [ "Papas a la francesa", "Salchicha premium", "Salsa rosada casera", "Salsa tártara" ]
  },
  {
    nombre: "Mixta Suprema",
    precio: 15000,
    descripcion: "Combinación perfecta de carnes con queso derretido",
    ingredientes: [ "Papas a la francesa", "Chorizo artesanal", "Salchicha premium", "Queso cheddar", "Salsa BBQ ahumada" ]
  },
  {
    nombre: "Rústica Premium",
    precio: 16000,
    descripcion: "Papas rústicas con tocineta y quesos selectos",
    ingredientes: [ "Papas rústicas", "Tocineta ahumada", "Queso mozzarella", "Queso cheddar", "Mayonesa de ajo" ]
  },
  {
    nombre: "Mexicana Picante",
    precio: 14500,
    descripcion: "Con jalapeños y salsa picante para los valientes",
    ingredientes: [ "Papas a la francesa", "Chorizo artesanal", "Jalapeños", "Queso cheddar", "Salsa picante", "Guacamole" ]
  }
]

salchipapas_data.each_with_index do |data, index|
  begin
    producto = Product.create!(
      nombre: data[:nombre],
      precio: data[:precio],
      descripcion: data[:descripcion],
      disponible: true,
      grupo: grupos["Salchipapas"]
    )

    data[:ingredientes].each do |ing_nombre|
      if ingredientes[ing_nombre]
        producto.ingredientes << ingredientes[ing_nombre]
      else
        puts "  ⚠️  Ingrediente no encontrado: #{ing_nombre}"
      end
    end

    if File.exist?(imagenes[:salchipapas])
      producto.imagen.attach(
        io: File.open(imagenes[:salchipapas]),
        filename: "Salchipapa.jpg",
        content_type: "image/jpeg"
      )
    end
  rescue => e
    puts "❌ Error creando salchipapa #{data[:nombre]}: #{e.message}"
    puts "   Detalles: #{e.record.errors.full_messages.join(', ')}" if e.respond_to?(:record) && e.record.errors.any?
  end
end

# === PIZZAS ===
pizzas_data = [
  {
    nombre: "Hawaiana Clásica",
    precio: 19000,
    descripcion: "La combinación perfecta de jamón serrano y piña fresca",
    ingredientes: [ "Masa de pizza artesanal", "Queso mozzarella", "Jamón serrano", "Piña fresca", "Salsa de tomate", "Orégano fresco" ]
  },
  {
    nombre: "Carne Premium",
    precio: 21000,
    descripcion: "Para los amantes de la carne con cebolla caramelizada",
    ingredientes: [ "Masa de pizza artesanal", "Carne de res premium", "Queso mozzarella", "Cebolla caramelizada", "Salsa de tomate", "Orégano fresco" ]
  },
  {
    nombre: "Vegetariana Gourmet",
    precio: 18500,
    descripcion: "Jardín de vegetales frescos con queso de cabra",
    ingredientes: [ "Masa de pizza artesanal", "Queso mozzarella", "Queso de cabra", "Tomate cherry", "Cebolla morada", "Maíz tierno", "Pimentón rojo", "Orégano fresco" ]
  },
  {
    nombre: "Pepperoni Suprema",
    precio: 20000,
    descripcion: "Clásica pepperoni con queso extra y hierbas frescas",
    ingredientes: [ "Masa de pizza artesanal", "Pepperoni", "Queso mozzarella", "Salsa de tomate", "Albahaca", "Orégano fresco" ]
  },
  {
    nombre: "Cuatro Quesos",
    precio: 22000,
    descripcion: "Para los amantes del queso: mozzarella, cheddar, parmesano y azul",
    ingredientes: [ "Masa de pizza artesanal", "Queso mozzarella", "Queso cheddar", "Queso parmesano", "Queso azul", "Orégano fresco" ]
  }
]

pizzas_data.each_with_index do |data, index|
  begin
    producto = Product.create!(
      nombre: data[:nombre],
      precio: data[:precio],
      descripcion: data[:descripcion],
      disponible: true,
      grupo: grupos["Pizzas"]
    )

    data[:ingredientes].each do |ing_nombre|
      if ingredientes[ing_nombre]
        producto.ingredientes << ingredientes[ing_nombre]
      else
        puts "  ⚠️  Ingrediente no encontrado: #{ing_nombre}"
      end
    end

    if File.exist?(imagenes[:pizzas])
      producto.imagen.attach(
        io: File.open(imagenes[:pizzas]),
        filename: "pizzas.jpg",
        content_type: "image/jpeg"
      )
    end
  rescue => e
    puts "❌ Error creando pizza #{data[:nombre]}: #{e.message}"
    puts "   Detalles: #{e.record.errors.full_messages.join(', ')}" if e.respond_to?(:record) && e.record.errors.any?
  end
end

# === BEBIDAS ===
bebidas_data = [
  { nombre: "Coca Cola", precio: 3500, descripcion: "Refrescante bebida gaseosa original" },
  { nombre: "Coca Cola Zero", precio: 3500, descripcion: "Todo el sabor, cero azúcar" },
  { nombre: "Sprite", precio: 3500, descripcion: "Limón lima refrescante" },
  { nombre: "Jugo Natural de Naranja", precio: 4500, descripcion: "Recién exprimido con pulpa natural" },
  { nombre: "Agua", precio: 2500, descripcion: "Agua cristalina purificada" },
  { nombre: "Limonada Natural", precio: 4000, descripcion: "Refrescante limonada casera con hierba buena" }
]

bebidas_data.each do |data|
  begin
    Product.create!(
      nombre: data[:nombre],
      precio: data[:precio],
      descripcion: data[:descripcion],
      disponible: true,
      grupo: grupos["Bebidas"]
    )
  rescue => e
    puts "❌ Error creando bebida #{data[:nombre]}: #{e.message}"
  end
end

# === POSTRES ===
postres_data = [
  { nombre: "Brownie con Helado", precio: 8500, descripcion: "Brownie caliente con helado de vainilla" },
  { nombre: "Cheesecake", precio: 7500, descripcion: "Cremoso cheesecake con frutos rojos" },
  { nombre: "Tres Leches", precio: 7000, descripcion: "Tradicional torta tres leches casera" },
  { nombre: "Flan Napolitano", precio: 6500, descripcion: "Suave flan con caramelo casero" }
]

postres_data.each do |data|
  begin
    Product.create!(
      nombre: data[:nombre],
      precio: data[:precio],
      descripcion: data[:descripcion],
      disponible: true,
      grupo: grupos["Postres"]
    )
  rescue => e
    puts "❌ Error creando postre #{data[:nombre]}: #{e.message}"
  end
end

puts "✅ Productos creados: #{Product.count}\n"

# ============================================================================
# 🎫 CUPONES
# ============================================================================

puts "🎫 Creando cupones promocionales..."

cupones_data = [
  {
    codigo: "BIENVENIDA20",
    tipo_descuento: "porcentaje",
    valor: 20.0,
    activo: true,
    expira_en: 30.days.from_now
  },
  {
    codigo: "FAMILIA5000",
    tipo_descuento: "fijo",
    valor: 5000.0,
    activo: true,
    expira_en: 60.days.from_now
  },
  {
    codigo: "ESTUDIANTE15",
    tipo_descuento: "porcentaje",
    valor: 15.0,
    activo: true,
    expira_en: 90.days.from_now
  },
  {
    codigo: "FINDE30",
    tipo_descuento: "porcentaje",
    valor: 30.0,
    activo: true,
    expira_en: 15.days.from_now
  },
  {
    codigo: "MEGA3000",
    tipo_descuento: "fijo",
    valor: 3000.0,
    activo: true,
    expira_en: 45.days.from_now
  },
  {
    codigo: "PIZZA25",
    tipo_descuento: "porcentaje",
    valor: 25.0,
    activo: true,
    expira_en: 20.days.from_now
  },
  {
    codigo: "TESTCUPON",
    tipo_descuento: "porcentaje",
    valor: 10.0,
    activo: true,
    expira_en: 10.days.from_now # Cupón de prueba válido
  },
  {
    codigo: "INACTIVO50",
    tipo_descuento: "fijo",
    valor: 2000.0,
    activo: false, # Inactivo para probar validaciones
    expira_en: 30.days.from_now
  }
]

cupones_data.each do |data|
  begin
    Coupon.create!(data)
  rescue => e
    puts "❌ Error creando cupón #{data[:codigo]}: #{e.message}"
    puts "   Detalles: #{e.record.errors.full_messages.join(', ')}" if e.respond_to?(:record) && e.record.errors.any?
  end
end

puts "✅ Cupones creados: #{Coupon.count}\n"



# ============================================================================
# 🖼️ BANNERS PROMOCIONALES
# ============================================================================

if defined?(Banner)
  puts "🖼️ Creando banners promocionales..."
  puts "⚠️  Modelo Banner detectado pero requiere configuración de campos"
  puts "✅ Banners creados: 0\n"
end

# ============================================================================
# 📊 RESUMEN FINAL
# ============================================================================

puts "\n" + "="*60
puts "🎉 SEED COMPLETADO EXITOSAMENTE"
puts "="*60
puts "👥 Usuarios creados: #{User.count}"
puts "   • #{User.where(rol: :admin).count} administrador(es)"
puts "   • #{User.where(rol: :cliente).count} cliente(s)"
puts ""
puts "🍽️ Grupos creados: #{Grupo.count}"
puts "🥬 Ingredientes creados: #{Ingrediente.count}"
puts "🍔 Productos creados: #{Product.count}"
grupos.each do |nombre, grupo|
  count = grupo.products.count
  puts "   • #{nombre}: #{count} productos"
end
puts ""
puts "🎫 Cupones creados: #{Coupon.count}"
puts "   • #{Coupon.where(activo: true).count} activos"
puts "   • #{Coupon.where(activo: false).count} inactivos"
puts ""

if defined?(Banner)
  puts "🖼️ Banners creados: #{Banner.count}"
  puts ""
end

puts "🔗 Relaciones ingrediente-producto: #{IngredienteProducto.count}"
puts "="*60
puts "✅ ¡Tu restaurante está listo para funcionar!"
puts "="*60

# Mostrar información de login
puts "\n🔑 CREDENCIALES DE ACCESO:"
puts "📧 Email: admin@admin.com"
puts "🔒 Password: rasdix-jePjor-kohsy6"
puts "\n💡 CUPONES DE PRUEBA:"
Coupon.where(activo: true).limit(3).each do |cupon|
  puts "   • #{cupon.codigo} - #{cupon.tipo_descuento} #{cupon.valor}#{'%' if cupon.tipo_descuento == 'porcentaje'}"
end
puts "\n🚀 ¡Disfruta probando tu aplicación!"
