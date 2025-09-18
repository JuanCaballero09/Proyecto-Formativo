// ignore: file_names
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://localhost:3000/api/v1";
  final storage = FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('${baseUrl}/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email, 
        'password': password,
        }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // Guardamos el token recibido en almacenamiento seguro
      await storage.write(key: 'token', value: data['token']);

      // ignore: avoid_print
      print("✅ Login exitoso");
      return true;
    } else {

      // ignore: avoid_print
      print("❌ Error en login: ${response.body}");
      return false;
    }
  }

  Future<bool> logout() async {
    final token = await storage.read(key: 'token');
    if (token == null) return false;

    final url = Uri.parse('${baseUrl}/logout');
    final response = await http.post(
      url,
      headers: {
        'Authorization': token,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      await storage.delete(key: 'token');
      // ignore: avoid_print
      print("✅ Sesión cerrada correctamente");
      return true;
    } else {
      // ignore: avoid_print
      print("❌ Error al cerrar sesión: ${response.body}");
      return false;
    }
  }

  Future<List<dynamic>?> getCategorias () async{
    final url = Uri.parse('${baseUrl}/categorias');

    final response = await http.get(url);
    print(response.body);

    if(response.statusCode == 200){
      final List<dynamic> decoded = jsonDecode(response.body);

      print('✅ cargado exitosamente');

      return decoded;
    }else{
      print('❌ Error: ${response.statusCode}');

      return null;

    }

  }


}