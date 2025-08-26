import 'dart:convert';
import 'package:http/http.dart' as http;

void main() async {
  print('🔍 Testing server connection...');
  
  try {
    final response = await http.get(Uri.parse('http://localhost:3000/api/v1/products'));
    print('📡 Response status: ${response.statusCode}');
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
      print('📦 Received ${data.length} products');
      
      if (data.isNotEmpty) {
        print('🔍 First product: ${data[0]}');
        
        // Check categories
        final categories = data.map((item) => item['category'] ?? item['categoria'] ?? 'Unknown').toSet();
        print('🏷️ Categories found: $categories');
      }
    } else {
      print('❌ HTTP Error: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('💥 Error: $e');
  }
}
