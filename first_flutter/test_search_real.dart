/// Script para probar la búsqueda con datos reales del backend
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  print('=== TEST DE BÚSQUEDA CON DATOS REALES ===\n');
  
  final baseUrl = 'http://localhost:3000/api/v1';
  final searchTerms = ['pizza', 'hamburguesa', 'taco', 'ensalada'];
  
  for (var term in searchTerms) {
    await testSearch(baseUrl, term);
  }
  
  print('\n=== TEST COMPLETADO ===');
  exit(0);
}

Future<void> testSearch(String baseUrl, String query) async {
  print('📍 Buscando: "$query"');
  
  try {
    final url = Uri.parse('$baseUrl/buscar?q=${Uri.encodeComponent(query)}');
    print('   URL: $url');
    
    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    
    final response = await http.get(url, headers: headers).timeout(
      const Duration(seconds: 10),
    );
    
    print('   Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      
      final productos = data['productos'] as List? ?? [];
      final grupos = data['grupos'] as List? ?? [];
      
      print('   ✅ Productos encontrados: ${productos.length}');
      print('   ✅ Grupos encontrados: ${grupos.length}');
      
      if (productos.isNotEmpty) {
        print('   📦 Primer producto:');
        final p = productos[0];
        print('      - ID: ${p['id']}');
        print('      - Nombre: ${p['nombre']}');
        print('      - Precio: ${p['precio']}');
      }
      
      if (grupos.isNotEmpty) {
        print('   📁 Primer grupo:');
        final g = grupos[0];
        print('      - ID: ${g['id']}');
        print('      - Nombre: ${g['nombre']}');
      }
    } else {
      print('   ❌ Error: ${response.statusCode}');
      print('   Respuesta: ${response.body}');
    }
    
  } catch (e) {
    print('   ❌ Excepción: $e');
  }
  
  print('');
}
