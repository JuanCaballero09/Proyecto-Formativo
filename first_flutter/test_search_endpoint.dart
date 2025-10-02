/// Script para probar el endpoint de búsqueda del backend
/// 
/// Este script puede ejecutarse de forma independiente para verificar
/// que el backend esté funcionando correctamente antes de probar en la app.
/// 
/// Uso:
/// dart test_server.dart

import 'dart:convert';
import 'dart:io';

void main() async {
  print('🧪 Probando endpoint de búsqueda...\n');
  
  // Configurar la URL del backend
  // Cambiar según tu configuración
  // El endpoint /buscar está en la raíz, no en /api
  const baseUrl = 'http://192.168.1.106:3001';
  const testQuery = 'pizza';
  
  try {
    final client = HttpClient();
    final uri = Uri.parse('$baseUrl/buscar?q=$testQuery');
    
    print('📡 Haciendo petición a: $uri');
    
    final request = await client.getUrl(uri);
    request.headers.set('Content-Type', 'application/json');
    
    final response = await request.close();
    final statusCode = response.statusCode;
    
    print('📊 Status Code: $statusCode\n');
    
    if (statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      final data = jsonDecode(body);
      
      print('✅ Respuesta exitosa!\n');
      print('📦 Datos recibidos:');
      print('   - Productos: ${data['productos']?.length ?? 0}');
      print('   - Grupos: ${data['grupos']?.length ?? 0}');
      print('   - Total: ${data['total'] ?? 0}\n');
      
      if (data['productos'] != null && data['productos'].isNotEmpty) {
        print('🍕 Primer producto:');
        final producto = data['productos'][0];
        print('   - ID: ${producto['id']}');
        print('   - Nombre: ${producto['nombre']}');
        print('   - Precio: \$${producto['precio']}');
        print('   - Imagen: ${producto['imagen_url'] ?? 'N/A'}\n');
      }
      
      if (data['grupos'] != null && data['grupos'].isNotEmpty) {
        print('📁 Primer grupo/categoría:');
        final grupo = data['grupos'][0];
        print('   - ID: ${grupo['id']}');
        print('   - Nombre: ${grupo['nombre']}');
        print('   - Imagen: ${grupo['imagen_url'] ?? 'N/A'}\n');
      }
      
      print('✨ El endpoint de búsqueda está funcionando correctamente!');
      
    } else {
      print('❌ Error HTTP $statusCode');
      final body = await response.transform(utf8.decoder).join();
      print('Respuesta del servidor:');
      print(body);
    }
    
    client.close();
    
  } catch (e) {
    print('❌ Error al conectar con el servidor:');
    print(e);
    print('\n💡 Verifica que:');
    print('   1. El backend esté corriendo');
    print('   2. La URL sea correcta: $baseUrl');
    print('   3. El endpoint /buscar esté implementado');
    print('   4. No haya problemas de CORS');
  }
}
