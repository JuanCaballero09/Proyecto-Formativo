Grupo.destroy_all
User.destroy_all
Product.destroy_all


ActiveRecord::Base.connection.reset_pk_sequence!('grupos')

puts "creando grupos"
Grupo.create(nombre: "Hamburguesa")
Grupo.create(nombre: "Pizza")
Grupo.create(nombre: "Salchipapa")
puts "Grupos creados #{Grupo.count}"

ActiveRecord::Base.connection.reset_pk_sequence!('users')

puts "creando usuarios"
User.create(
  email: "admin@admin",
  password: "123456",
  nombre: "Admin",
  apellido: "Admin",
  telefono: "123456789",
  rol: :admin
)
User.create(
  email: "juanes0921200@gmail.com",
  password: "09212006",
  nombre: "Juan Esteban",
  apellido: "Caballero Goenaga",
  telefono: "3024681298",
  rol: :cliente
)
puts "Usuarios creados #{User.count}"


ActiveRecord::Base.connection.reset_pk_sequence!('products')

puts "creando productos"
Product.create(
  nombre: "Hamburguesa con queso",
  precio: 10.0,
  descripcion: "Deliciosa hamburguesa con queso",
  disponible: true,
  imagen: "https://example.com/hamburguesa.jpg",
  grupo_id: Grupo.find_by(nombre: "Hamburguesa").id
)
puts "Productos creados #{Product.count}"