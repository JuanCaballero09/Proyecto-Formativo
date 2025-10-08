/// Test rápido para verificar las correcciones de búsqueda
import 'dart:io';
import 'lib/service/ApiService.dart';
import 'lib/models/search_result.dart';

void main() async {
  print('╔════════════════════════════════════════╗');
  print('║  TEST: Correcciones de Búsqueda       ║');
  print('╚════════════════════════════════════════╝\n');

  final apiService = ApiService();
  
  print('🔗 Conectando a: ${apiService.baseUrl}\n');

  // Test 1: Búsqueda simple
  print('━━━ TEST 1: Búsqueda de "pizza" ━━━');
  try {
    final result = await apiService.searchProducts('pizza');
    final productos = result['productos'] as List;
    
    print('✅ Respuesta recibida');
    print('📦 Productos encontrados: ${productos.length}\n');
    
    if (productos.isNotEmpty) {
      final primerProducto = productos[0];
      print('📋 Primer producto (JSON crudo):');
      print('   ID: ${primerProducto['id']}');
      print('   Nombre: ${primerProducto['nombre']}');
      print('   Grupo ID: ${primerProducto['grupo_id']}');
      print('   Imagen URL: ${primerProducto['imagen_url']}');
      print('   Tipo de imagen_url: ${primerProducto['imagen_url'].runtimeType}');
      print('');
      
      // Test 2: Crear SearchResult
      print('━━━ TEST 2: Conversión a SearchResult ━━━');
      try {
        final searchResult = SearchResult.fromProductJson(primerProducto);
        print('✅ SearchResult creado exitosamente');
        print('   ID: ${searchResult.id}');
        print('   Nombre: ${searchResult.name}');
        print('   Imagen: ${searchResult.image}');
        print('   Precio: \$${searchResult.price}');
        print('');
        
        // Test 3: Intentar obtener producto desde API
        if (searchResult.rawData?['grupo_id'] != null) {
          print('━━━ TEST 3: Obtener producto desde API ━━━');
          final grupoId = searchResult.rawData!['grupo_id'];
          final productId = int.parse(searchResult.id);
          
          print('🔍 Solicitando:');
          print('   Grupo ID: $grupoId');
          print('   Product ID: $productId');
          print('');
          
          try {
            final product = await apiService.getProductByCategoryAndId(
              grupoId is int ? grupoId : int.parse(grupoId.toString()),
              productId,
            );
            
            print('✅ Producto obtenido desde API');
            print('   ID: ${product.id}');
            print('   Nombre: ${product.name}');
            print('   Categoría: ${product.category}');
            print('   Precio: \$${product.price}');
            print('   Descripción: ${product.description}');
            print('   Ingredientes: ${product.ingredients}');
            print('');
            
          } catch (e) {
            print('❌ Error al obtener producto desde API:');
            print('   $e');
            print('');
          }
        }
        
      } catch (e) {
        print('❌ Error al crear SearchResult:');
        print('   $e');
        print('   Stack trace: ${StackTrace.current}');
        print('');
      }
    } else {
      print('⚠️  No se encontraron productos');
    }
    
  } catch (e) {
    print('❌ Error en búsqueda:');
    print('   $e');
    print('');
  }

  print('╔════════════════════════════════════════╗');
  print('║  TEST COMPLETADO                       ║');
  print('╚════════════════════════════════════════╝');
  
  exit(0);
}
