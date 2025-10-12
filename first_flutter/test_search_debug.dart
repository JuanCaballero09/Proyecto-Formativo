/// Script de prueba para debug de búsqueda
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('🔍 Iniciando pruebas de búsqueda...\n');

  // URLs a probar
  final urls = [
    'http://localhost:3000/api/v1/buscar?q=pizza',
    'http://192.168.1.106:3001/buscar?q=pizza',
    'http://localhost:3001/buscar?q=pizza',
  ];

  for (var url in urls) {
    await testUrl(url);
    print('\n' + '=' * 80 + '\n');
  }
}

Future<void> testUrl(String url) async {
  print('🌐 Probando URL: $url');
  
  try {
    final uri = Uri.parse(url);
    print('📡 Haciendo petición GET...');
    
    final response = await http.get(uri).timeout(
      const Duration(seconds: 5),
      onTimeout: () {
        throw Exception('Timeout después de 5 segundos');
      },
    );

    print('✅ Respuesta recibida');
    print('📊 Status Code: ${response.statusCode}');
    print('📦 Headers: ${response.headers}');
    print('📄 Body length: ${response.body.length} caracteres');
    print('📝 Body:');
    print(response.body);

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        print('\n✅ JSON válido parseado');
        print('Estructura:');
        print('  - productos: ${data['productos']?.length ?? 0} items');
        print('  - grupos: ${data['grupos']?.length ?? 0} items');
        
        if (data['productos'] != null && data['productos'].isNotEmpty) {
          print('\n🍕 Primer producto:');
          print(jsonEncode(data['productos'][0]));
        }
        
        if (data['grupos'] != null && data['grupos'].isNotEmpty) {
          print('\n📁 Primer grupo:');
          print(jsonEncode(data['grupos'][0]));
        }
      } catch (e) {
        print('❌ Error al parsear JSON: $e');
      }
    } else {
      print('⚠️ Status code no exitoso');
    }
  } catch (e) {
    print('❌ ERROR: $e');
  }
}
