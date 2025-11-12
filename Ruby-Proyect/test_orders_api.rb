#!/usr/bin/env ruby
# Script de pruebas para API de órdenes
# Prueba flujos de usuario autenticado e invitado

require 'net/http'
require 'json'
require 'uri'

BASE_URL = ENV['API_URL'] || 'http://localhost:3000'
API_BASE = "#{BASE_URL}/api/v1"

def print_separator
  puts "\n" + "="*80 + "\n"
end

def print_test(name)
  print_separator
  puts "🧪 TEST: #{name}"
  print_separator
end

def make_request(method, path, body: nil, headers: {})
  uri = URI("#{API_BASE}#{path}")
  
  http = Net::HTTP.new(uri.host, uri.port)
  
  case method
  when :get
    request = Net::HTTP::Get.new(uri)
  when :post
    request = Net::HTTP::Post.new(uri)
  when :patch
    request = Net::HTTP::Patch.new(uri)
  end
  
  request['Content-Type'] = 'application/json'
  headers.each { |k, v| request[k] = v }
  request.body = body.to_json if body
  
  response = http.request(request)
  
  puts "📤 #{method.upcase} #{path}"
  puts "📥 Status: #{response.code}"
  
  begin
    data = JSON.parse(response.body)
    puts "📄 Response: #{JSON.pretty_generate(data)}"
    data
  rescue JSON::ParserError
    puts "📄 Response: #{response.body}"
    nil
  end
end

# ============================================
# PRUEBAS DE USUARIO INVITADO
# ============================================

print_test("Crear orden como invitado")
guest_order = make_request(:post, '/orders', body: {
  items: [
    { product_id: 1, quantity: 2 },
    { product_id: 2, quantity: 1 }
  ],
  direccion: "Calle 123 #45-67, Bogotá",
  guest_nombre: "Juan",
  guest_apellido: "Pérez",
  guest_email: "juan.perez@test.com",
  guest_telefono: "3001234567"
})

if guest_order && guest_order['code']
  guest_code = guest_order['code']
  guest_email = "juan.perez@test.com"
  
  print_test("Obtener órdenes de invitado por email")
  make_request(:get, "/orders?email=#{guest_email}")
  
  print_test("Obtener orden específica de invitado")
  make_request(:get, "/orders/#{guest_code}?email=#{guest_email}")
  
  print_test("Cancelar orden de invitado")
  make_request(:patch, "/orders/#{guest_code}/cancel", headers: {
    'X-Guest-Email' => guest_email
  })
else
  puts "❌ No se pudo crear orden de invitado"
end

# ============================================
# PRUEBAS DE USUARIO AUTENTICADO
# ============================================

print_test("Login de usuario")
login_response = make_request(:post, '/login', body: {
  email: 'test@example.com',
  password: 'password123'
})

if login_response && login_response['token']
  token = login_response['token']
  puts "✅ Token obtenido: #{token[0..20]}..."
  
  print_test("Crear orden como usuario autenticado")
  auth_order = make_request(:post, '/orders', 
    body: {
      items: [
        { product_id: 3, quantity: 1 },
        { product_id: 4, quantity: 3 }
      ],
      direccion: "Carrera 7 #32-16, Medellín",
      coupon_code: "DESCUENTO10"
    },
    headers: { 'Authorization' => token }
  )
  
  if auth_order && auth_order['code']
    auth_code = auth_order['code']
    
    print_test("Obtener todas las órdenes del usuario autenticado")
    make_request(:get, '/orders', headers: { 'Authorization' => token })
    
    print_test("Obtener orden específica del usuario autenticado")
    make_request(:get, "/orders/#{auth_code}", headers: { 'Authorization' => token })
    
    print_test("Cancelar orden del usuario autenticado")
    make_request(:patch, "/orders/#{auth_code}/cancel", headers: { 'Authorization' => token })
  else
    puts "❌ No se pudo crear orden de usuario autenticado"
  end
else
  puts "⚠️  No se pudo hacer login. Asegúrate de tener un usuario de prueba."
  puts "   Puedes crear uno con: rails console"
  puts "   User.create!(email: 'test@example.com', password: 'password123', nombre: 'Test', apellido: 'User', telefono: '3001234567')"
end

# ============================================
# PRUEBAS DE VALIDACIÓN
# ============================================

print_test("Intentar crear orden de invitado sin datos requeridos")
make_request(:post, '/orders', body: {
  items: [{ product_id: 1, quantity: 1 }],
  direccion: "Calle 1"
})

print_test("Intentar crear orden sin productos")
make_request(:post, '/orders', body: {
  direccion: "Calle 123",
  guest_nombre: "Test",
  guest_apellido: "User",
  guest_email: "test@test.com",
  guest_telefono: "300"
})

print_test("Intentar buscar órdenes de invitado sin email")
make_request(:get, '/orders')

print_test("Intentar buscar órdenes con email inválido")
make_request(:get, '/orders?email=invalid-email')

print_separator
puts "✅ Pruebas completadas"
print_separator
