/// Script de prueba para verificar la búsqueda con datos reales del backend
import 'dart:io';
import 'lib/service/ApiService.dart';

void main() async {
  print('====================================');
  print('PRUEBA DE BÚSQUEDA CON DATOS REALES');
  print('====================================\n');

  // Crear instancia del servicio API
  final apiService = ApiService();
  
  print('🔗 URL Base: ${apiService.baseUrl}');
  print('📡 Endpoint de búsqueda: ${apiService.baseUrl}/buscar\n');

  // Lista de términos de búsqueda para probar
  final testQueries = ['pizza', 'hamburguesa', 'taco', 'ensalada', 'pollo'];

  for (var query in testQueries) {
    print('\n━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    print('🔍 Buscando: "$query"');
    print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    
    try {
      final result = await apiService.searchProducts(query);
      
      final productos = result['productos'] as List;
      final grupos = result['grupos'] as List;
      
      print('✅ Búsqueda exitosa!');
      print('   📦 Productos encontrados: ${productos.length}');
      print('   📁 Grupos encontrados: ${grupos.length}');
      
      if (productos.isNotEmpty) {
        print('\n   Productos:');
        for (var product in productos) {
          print('   - ${product['nombre']} (\$${product['precio']})');
        }
      }
      
      if (grupos.isNotEmpty) {
        print('\n   Grupos/Categorías:');
        for (var grupo in grupos) {
          print('   - ${grupo['nombre']}');
        }
      }
      
      if (productos.isEmpty && grupos.isEmpty) {
        print('   ℹ️  No se encontraron resultados');
      }
      
    } catch (e) {
      print('❌ Error en la búsqueda:');
      print('   $e');
    }
    
    // Pequeña pausa entre búsquedas
    await Future.delayed(Duration(milliseconds: 500));
  }

  print('\n\n====================================');
  print('PRUEBAS COMPLETADAS');
  print('====================================');
  
  exit(0);
}
