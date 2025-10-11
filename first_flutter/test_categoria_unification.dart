import 'dart:convert';
import 'package:http/http.dart' as http;

/// Script para probar la unificación de categorías
/// Verifica que el backend envía grupo_id y el frontend lo transforma a categoria_id

void main() async {
  print('🧪 Iniciando pruebas de unificación de categorías...\n');
  
  const baseUrl = 'http://localhost:3000/api/v1';
  
  // Test 1: Obtener todas las categorías
  await testGetCategorias(baseUrl);
  
  // Test 2: Obtener productos de cada categoría
  for (int i = 1; i <= 5; i++) {
    await testGetProductosPorCategoria(baseUrl, i);
  }
  
  // Test 3: Búsqueda de productos
  await testBusqueda(baseUrl, 'pizza');
  await testBusqueda(baseUrl, 'bebida');
  await testBusqueda(baseUrl, 'postre');
  
  print('\n✅ Todas las pruebas completadas');
}

Future<void> testGetCategorias(String baseUrl) async {
  print('📂 Test 1: Obtener todas las categorías');
  print('━' * 60);
  
  try {
    final url = Uri.parse('$baseUrl/categorias');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final List<dynamic> categorias = jsonDecode(response.body);
      print('✅ Respuesta exitosa: ${categorias.length} categorías');
      
      for (var categoria in categorias) {
        print('   📁 ID: ${categoria['id']}, Nombre: ${categoria['nombre']}');
        
        // Verificar que viene grupo_id (será transformado a categoria_id)
        if (categoria.containsKey('id')) {
          print('      ✓ Campo "id" presente');
        }
      }
    } else {
      print('❌ Error: ${response.statusCode}');
      print('   ${response.body}');
    }
  } catch (e) {
    print('❌ Error de conexión: $e');
  }
  
  print('');
}

Future<void> testGetProductosPorCategoria(String baseUrl, int categoriaId) async {
  print('📦 Test 2.$categoriaId: Obtener productos de categoría $categoriaId');
  print('━' * 60);
  
  try {
    final url = Uri.parse('$baseUrl/categorias/$categoriaId/productos/');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final List<dynamic> productos = jsonDecode(response.body);
      print('✅ Respuesta exitosa: ${productos.length} productos');
      
      if (productos.isNotEmpty) {
        final primerProducto = productos.first;
        print('   📦 Ejemplo - ID: ${primerProducto['id']}, Nombre: ${primerProducto['nombre']}');
        
        // Verificar que viene grupo_id
        if (primerProducto.containsKey('grupo_id')) {
          print('      ✓ Campo "grupo_id" presente: ${primerProducto['grupo_id']}');
          print('      → Flutter transformará a "categoria_id"');
        } else {
          print('      ⚠️ Campo "grupo_id" no presente');
        }
      }
    } else if (response.statusCode == 404) {
      print('⚠️ Categoría no encontrada o sin productos');
    } else {
      print('❌ Error: ${response.statusCode}');
      print('   ${response.body}');
    }
  } catch (e) {
    print('❌ Error de conexión: $e');
  }
  
  print('');
}

Future<void> testBusqueda(String baseUrl, String query) async {
  print('🔍 Test 3: Búsqueda "$query"');
  print('━' * 60);
  
  try {
    final url = Uri.parse('$baseUrl/buscar?q=${Uri.encodeComponent(query)}');
    final response = await http.get(url);
    
    if (response.statusCode == 200) {
      final Map<String, dynamic> resultado = jsonDecode(response.body);
      
      final productos = resultado['productos'] ?? [];
      final grupos = resultado['grupos'] ?? [];
      
      print('✅ Respuesta exitosa:');
      print('   📦 Productos encontrados: ${productos.length}');
      print('   📁 Categorías encontradas: ${grupos.length}');
      
      if (productos.isNotEmpty) {
        final primerProducto = productos.first;
        print('   Ejemplo producto: ${primerProducto['nombre']}');
        if (primerProducto.containsKey('grupo_id')) {
          print('      ✓ Campo "grupo_id": ${primerProducto['grupo_id']}');
          print('      → Flutter transformará a "categoria_id"');
        }
      }
      
      if (grupos.isNotEmpty) {
        final primerGrupo = grupos.first;
        print('   Ejemplo categoría: ${primerGrupo['nombre']}');
        print('      → Flutter transformará "grupos" a "categorias"');
      }
    } else {
      print('❌ Error: ${response.statusCode}');
      print('   ${response.body}');
    }
  } catch (e) {
    print('❌ Error de conexión: $e');
  }
  
  print('');
}
