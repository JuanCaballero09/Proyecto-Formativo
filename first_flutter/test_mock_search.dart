import 'package:first_flutter/service/ApiService.dart';

void main() async {
  print('🧪 Probando búsqueda con mock data\n');
  
  final apiService = ApiService();
  
  // Probar diferentes búsquedas
  final queries = ['pizza', 'hamburguesa', 'taco', 'ensalada', 'pollo', 'queso'];
  
  for (var query in queries) {
    print('═' * 80);
    print('🔍 Buscando: "$query"');
    print('─' * 80);
    
    try {
      final results = await apiService.searchProducts(query);
      
      final productos = results['productos'] as List;
      final grupos = results['grupos'] as List;
      final total = results['total'] as int;
      
      print('✅ Resultados encontrados: $total');
      print('   📦 Productos: ${productos.length}');
      print('   📁 Grupos: ${grupos.length}');
      
      if (productos.isNotEmpty) {
        print('\n   🍕 Productos encontrados:');
        for (var p in productos) {
          print('      - ${p['nombre']} (\$${p['precio']})');
        }
      }
      
      if (grupos.isNotEmpty) {
        print('\n   📂 Grupos encontrados:');
        for (var g in grupos) {
          print('      - ${g['nombre']}');
        }
      }
      
      if (total == 0) {
        print('   ℹ️  No se encontraron resultados');
      }
      
    } catch (e) {
      print('❌ Error: $e');
    }
    
    print('');
  }
  
  print('═' * 80);
  print('✅ Pruebas completadas!');
  print('═' * 80);
}
