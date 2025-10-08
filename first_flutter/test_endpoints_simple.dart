import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('🧪 Prueba simple de búsqueda\n');
  
  // Probar diferentes URLs y formatos
  final tests = [
    {
      'url': 'http://localhost:3000/es/buscar?q=pizza',
      'headers': {'Accept': 'application/json'},
      'name': 'Con header JSON'
    },
    {
      'url': 'http://localhost:3000/es/buscar.json?q=pizza',
      'headers': {},
      'name': 'Con extensión .json'
    },
    {
      'url': 'http://localhost:3000/es/productos',
      'headers': {'Accept': 'application/json'},
      'name': 'Endpoint productos'
    },
    {
      'url': 'http://localhost:3000/es/productos.json',
      'headers': {},
      'name': 'Productos con .json'
    },
    {
      'url': 'http://localhost:3000/es/categorias',
      'headers': {'Accept': 'application/json'},
      'name': 'Endpoint categorías'
    },
    {
      'url': 'http://localhost:3000/es/categorias.json',
      'headers': {},
      'name': 'Categorías con .json'
    },
  ];

  for (var test in tests) {
    await testEndpoint(
      test['url'] as String,
      Map<String, String>.from(test['headers'] as Map),
      test['name'] as String,
    );
    print('\n' + '='*80 + '\n');
  }
}

Future<void> testEndpoint(String url, Map<String, String> headers, String testName) async {
  print('🌐 Test: $testName');
  print('📍 URL: $url');
  print('📋 Headers: $headers');
  
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: headers,
    ).timeout(const Duration(seconds: 5));

    print('✅ Status: ${response.statusCode}');
    print('📄 Content-Type: ${response.headers['content-type']}');
    print('📏 Body length: ${response.body.length}');
    
    // Intentar detectar si es HTML o JSON
    final body = response.body.trim();
    if (body.startsWith('{') || body.startsWith('[')) {
      print('✅ Parece ser JSON válido');
      try {
        final data = jsonDecode(body);
        print('✅ JSON parseado exitosamente');
        if (data is Map) {
          print('📦 Claves: ${data.keys.join(', ')}');
          if (data['productos'] != null) {
            print('   - productos: ${(data['productos'] as List).length} items');
          }
          if (data['grupos'] != null) {
            print('   - grupos: ${(data['grupos'] as List).length} items');
          }
        } else if (data is List) {
          print('📦 Array con ${data.length} elementos');
          if (data.isNotEmpty) {
            print('   - Primer elemento: ${data[0].runtimeType}');
          }
        }
      } catch (e) {
        print('❌ Error parseando JSON: $e');
      }
    } else if (body.toLowerCase().contains('<!doctype') || body.toLowerCase().contains('<html')) {
      print('⚠️  Es HTML, no JSON');
    } else {
      print('⚠️  Formato desconocido');
      print('Primeros 200 caracteres:');
      print(body.substring(0, body.length > 200 ? 200 : body.length));
    }
    
  } catch (e) {
    print('❌ Error: $e');
  }
}
