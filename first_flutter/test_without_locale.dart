import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('🧪 Prueba de endpoints sin locale\n');
  
  final tests = [
    'http://localhost:3000/buscar?q=pizza',
    'http://localhost:3000/buscar.json?q=pizza',
    'http://localhost:3000/productos',
    'http://localhost:3000/productos.json',
    'http://localhost:3000/categorias',
    'http://localhost:3000/categorias.json',
    'http://localhost:3000/api/buscar?q=pizza',
    'http://localhost:3000/api/productos',
    'http://localhost:3000/api/categorias',
  ];

  for (var url in tests) {
    await testUrl(url);
  }
}

Future<void> testUrl(String url) async {
  print('🌐 Probando: $url');
  
  try {
    final response = await http.get(Uri.parse(url)).timeout(
      const Duration(seconds: 3),
    );

    print('   Status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'] ?? '';
      print('   Content-Type: $contentType');
      
      if (contentType.contains('json')) {
        print('   ✅ JSON detectado!');
        try {
          final data = jsonDecode(response.body);
          print('   ✅ Parseado: ${data.runtimeType}');
          if (data is List) {
            print('   📦 ${data.length} elementos');
          } else if (data is Map) {
            print('   📦 Claves: ${data.keys.join(', ')}');
          }
        } catch (e) {
          print('   ❌ Error parseando: $e');
        }
      }
    }
    
  } catch (e) {
    print('   ❌ Error: $e');
  }
  print('');
}
