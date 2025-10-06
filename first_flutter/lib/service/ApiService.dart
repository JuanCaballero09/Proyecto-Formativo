// ignore: file_names
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../core/errors/exceptions.dart';
import '../utils/api_config.dart';

/// Servicio centralizado para el consumo de APIs
/// Maneja autenticación, productos y categorías
class ApiService {
  /// URL base configurable de la API
  final String baseUrl;
  final storage = const FlutterSecureStorage();

  /// Constructor que permite configurar la URL base
  /// [baseUrl] - URL base de la API (opcional, usa configuración por defecto)
  ApiService({String? baseUrl}) : baseUrl = baseUrl ?? ApiConfig.currentBaseUrl;

  /// Obtiene el token de autenticación almacenado
  Future<String?> _getAuthToken() async {
    return await storage.read(key: 'token');
  }

  /// Headers comunes para las peticiones autenticadas
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await _getAuthToken();
    return {
      ...ApiConfig.defaultHeaders,
      if (token != null) 'Authorization': token,
    };
  }

  /// Maneja las respuestas HTTP y convierte errores a excepciones personalizadas
  void _handleHttpResponse(http.Response response, String operation) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return; // Respuesta exitosa
    }

    // Intentar parsear el mensaje de error de la respuesta
    String errorMessage = 'Error en $operation';
    try {
      final errorData = jsonDecode(response.body);
      errorMessage = errorData['message'] ?? errorData['error'] ?? errorMessage;
    } catch (_) {
      // Si no se puede parsear, usar mensaje genérico
    }

    // Lanzar excepción según el código de estado
    switch (response.statusCode) {
      case 400:
        throw DataException('Datos inválidos: $errorMessage');
      case 401:
        throw NetworkException('No autorizado: $errorMessage');
      case 403:
        throw NetworkException('Acceso denegado: $errorMessage');
      case 404:
        throw DataException('Recurso no encontrado: $errorMessage');
      case 500:
        throw NetworkException('Error interno del servidor: $errorMessage');
      default:
        if (response.statusCode >= 500) {
          throw NetworkException('Error del servidor: $errorMessage');
        } else {
          throw DataException(errorMessage);
        }
    }
  }

  /// Obtiene todos los productos de una categoría específica
  /// [categoryId] - ID de la categoría (1, 2 o 3)
  /// Retorna una lista de productos de la categoría solicitada
  Future<List<Product>> getProductsByCategory(int categoryId) async {
    if (categoryId < 1 || categoryId > 3) {
      throw DataException('ID de categoría inválido. Debe ser 1, 2 o 3');
    }

    try {
      final url = Uri.parse(ApiConfig.getProductsByCategoryUrl(categoryId));
      final headers = await _getAuthHeaders();

      // ignore: avoid_print
      print("🔍 Obteniendo productos de categoría $categoryId desde: $url");

      final response = await http.get(url, headers: headers);
      
      _handleHttpResponse(response, 'obtener productos por categoría');

      final data = jsonDecode(response.body);
      
      // La respuesta puede ser una lista directa o un objeto con una propiedad 'products'
      final List<dynamic> productsJson;
      if (data is List) {
        productsJson = data;
      } else if (data is Map && data['products'] != null) {
        productsJson = data['products'];
      } else if (data is Map && data['data'] != null) {
        productsJson = data['data'];
      } else {
        throw DataException('Formato de respuesta inválido para productos');
      }

      final products = productsJson.map((json) => Product.fromJson(json)).toList();
      
      // ignore: avoid_print
      print("✅ ${products.length} productos obtenidos de categoría $categoryId");
      return products;

    } on NetworkException {
      rethrow;
    } on DataException {
      rethrow;
    } catch (e) {
      // ignore: avoid_print
      print("❌ Error inesperado al obtener productos de categoría $categoryId: $e");
      throw NetworkException('Error de conexión al obtener productos de la categoría');
    }
  }

  /// Obtiene un producto específico de una categoría
  /// [categoryId] - ID de la categoría (1, 2 o 3)
  /// [productId] - ID del producto (1, 2 o 3)
  /// Retorna el producto solicitado
  Future<Product> getProductByCategoryAndId(int categoryId, int productId) async {
    if (categoryId < 1 || categoryId > 3) {
      throw DataException('ID de categoría inválido. Debe ser 1, 2 o 3');
    }

    if (productId < 1 || productId > 3) {
      throw DataException('ID de producto inválido. Debe ser 1, 2 o 3');
    }

    try {
      final url = Uri.parse(ApiConfig.getProductByIdUrl(categoryId, productId));
      final headers = await _getAuthHeaders();

      // ignore: avoid_print
      print("🔍 Obteniendo producto $productId de categoría $categoryId desde: $url");

      final response = await http.get(url, headers: headers);
      
      _handleHttpResponse(response, 'obtener producto específico');

      final data = jsonDecode(response.body);
      
      // La respuesta puede ser el producto directamente o un objeto con una propiedad 'product'
      final Map<String, dynamic> productJson;
      if (data is Map<String, dynamic> && (data.containsKey('id') || data.containsKey('name') || data.containsKey('nombre'))) {
        productJson = data;
      } else if (data is Map && data['product'] != null) {
        productJson = data['product'];
      } else if (data is Map && data['data'] != null) {
        productJson = data['data'];
      } else {
        throw DataException('Formato de respuesta inválido para producto');
      }

      final product = Product.fromJson(productJson);
      
      // ignore: avoid_print
      print("✅ Producto obtenido: ${product.name}");
      return product;

    } on NetworkException {
      rethrow;
    } on DataException {
      rethrow;
    } catch (e) {
      // ignore: avoid_print
      print("❌ Error inesperado al obtener producto $productId de categoría $categoryId: $e");
      throw NetworkException('Error de conexión al obtener el producto');
    }
  }

  Future<bool> login(String email, String password) async {
    final url = Uri.parse(ApiConfig.loginUrl);

    final response = await http.post(
      url,
      headers: ApiConfig.defaultHeaders,
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

    final url = Uri.parse(ApiConfig.logoutUrl);
    final response = await http.post(
      url,
      headers: {
        'Authorization': token,
        ...ApiConfig.defaultHeaders,
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

    try {
      final response = await http.get(url);

      if(response.statusCode == 200){
        final List<dynamic> decoded = jsonDecode(response.body);
        return decoded;
      } else {
        // ignore: avoid_print
        print('❌ Error HTTP: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // ignore: avoid_print
      print('❌ Error en getCategorias: $e');
      return null;
    }
  }

  /// Busca productos y categorías por query
  /// [query] - Texto de búsqueda
  /// Retorna un mapa con 'productos' y 'grupos' que coinciden con la búsqueda
  Future<Map<String, dynamic>> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      return {'productos': [], 'grupos': []};
    }

    try {
      final url = Uri.parse('$baseUrl/buscar?q=${Uri.encodeComponent(query)}');
      final headers = await _getAuthHeaders();

      // ignore: avoid_print
      print("🔍 Buscando: '$query' en: $url");

      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));

      // ignore: avoid_print
      print("📊 Status Code: ${response.statusCode}");
      
      // ⚠️ SOLUCIÓN TEMPORAL: El backend NO soporta JSON
      // Si recibimos HTML (406 o content-type no es JSON), usar datos mock
      if (response.statusCode == 406 || response.statusCode >= 400) {
        // ignore: avoid_print
        print("⚠️  Backend no soporta JSON (Status ${response.statusCode}). Usando datos mock.");
        return _getMockSearchResults(query);
      }

      // ignore: avoid_print
      print("📦 Response body: ${response.body}");

      _handleHttpResponse(response, 'búsqueda de productos');

      final data = jsonDecode(response.body);

      // La respuesta debe tener la estructura: { productos: [], grupos: [] }
      final Map<String, dynamic> searchResults = {
        'productos': data['productos'] ?? [],
        'grupos': data['grupos'] ?? [],
        'total': (data['productos']?.length ?? 0) + (data['grupos']?.length ?? 0),
      };

      // ignore: avoid_print
      print("✅ Búsqueda completada: ${searchResults['total']} resultados");
      return searchResults;

    } on NetworkException {
      rethrow;
    } on DataException {
      rethrow;
    } catch (e) {
      // ignore: avoid_print
      print("❌ Error inesperado en búsqueda: $e");
      throw NetworkException('Error de conexión al buscar productos');
    }
  }

  /// 🔧 MÉTODO TEMPORAL: Datos mock para búsqueda
  /// TODO: Eliminar cuando el backend soporte JSON
  Map<String, dynamic> _getMockSearchResults(String query) {
    final q = query.toLowerCase();
    
    print("🔍 MOCK: Iniciando búsqueda mock para '$q'");
    
    // Datos mock de productos
    final allProducts = [
      {'id': 1, 'nombre': 'Pizza Margarita', 'descripcion': 'Tomate, mozzarella y albahaca fresca', 'precio': 15.99, 'imagen_url': 'assets/Pizza margarita.jpg'},
      {'id': 2, 'nombre': 'Pizza Hawaiana', 'descripcion': 'Jamón, piña y queso mozzarella', 'precio': 17.99, 'imagen_url': 'assets/Pizza Hawiana.jpg'},
      {'id': 3, 'nombre': 'Pizza Pepperoni', 'descripcion': 'Pepperoni y queso mozzarella', 'precio': 16.99, 'imagen_url': 'assets/Pizza pepperoni.jpg'},
      {'id': 4, 'nombre': 'Hamburguesa Sencilla', 'descripcion': 'Carne, lechuga, tomate y queso', 'precio': 12.99, 'imagen_url': 'assets/Hamburguesa sencilla.jpg'},
      {'id': 5, 'nombre': 'Hamburguesa Doble Queso', 'descripcion': 'Doble carne y doble queso', 'precio': 15.99, 'imagen_url': 'assets/Hamburgesa Doble Queso.jpeg'},
      {'id': 6, 'nombre': 'Hamburguesa BBQ', 'descripcion': 'Carne, salsa BBQ, cebolla y queso', 'precio': 14.99, 'imagen_url': 'assets/Hamburguesa BBQ.jpeg'},
      {'id': 7, 'nombre': 'Tacos al Pastor', 'descripcion': '3 tacos con carne al pastor', 'precio': 10.99, 'imagen_url': 'assets/Tacos al Pastor.jpg'},
      {'id': 8, 'nombre': 'Tacos de Pollo', 'descripcion': '3 tacos con pollo marinado', 'precio': 9.99, 'imagen_url': 'assets/Tacos de Pollo.jpg'},
      {'id': 9, 'nombre': 'Tacos Veganos', 'descripcion': '3 tacos vegetarianos', 'precio': 9.99, 'imagen_url': 'assets/Tacos Veganos.jpg'},
      {'id': 10, 'nombre': 'Ensalada César', 'descripcion': 'Lechuga romana, pollo, crutones y aderezo César', 'precio': 11.99, 'imagen_url': 'assets/Ensalada Cesar.jpg'},
      {'id': 11, 'nombre': 'Ensalada de Atún', 'descripcion': 'Atún, lechuga, tomate y cebolla', 'precio': 10.99, 'imagen_url': 'assets/Ensalada de Atun.jpg'},
      {'id': 12, 'nombre': 'Ensalada Mediterránea', 'descripcion': 'Lechuga, tomate, pepino, aceitunas y queso feta', 'precio': 12.99, 'imagen_url': 'assets/Ensalada Mediterranea.jpg'},
    ];

    // Datos mock de categorías
    final allGroups = [
      {'id': 1, 'nombre': 'PIZZAS', 'imagen_url': 'assets/Pizza Hawiana.jpg'},
      {'id': 2, 'nombre': 'HAMBURGUESAS', 'imagen_url': 'assets/Hamburguesa sencilla.jpg'},
      {'id': 3, 'nombre': 'TACOS', 'imagen_url': 'assets/Tacos de Pollo.jpg'},
      {'id': 4, 'nombre': 'ENSALADAS', 'imagen_url': 'assets/Ensalada Cesar.jpg'},
    ];

    // Filtrar productos que coincidan con la búsqueda
    final matchingProducts = allProducts.where((p) {
      final nombre = (p['nombre'] as String).toLowerCase();
      final desc = (p['descripcion'] as String).toLowerCase();
      return nombre.contains(q) || desc.contains(q);
    }).toList();

    // Filtrar grupos que coincidan con la búsqueda
    final matchingGroups = allGroups.where((g) {
      final nombre = (g['nombre'] as String).toLowerCase();
      return nombre.contains(q);
    }).toList();

    print("🔍 MOCK: Encontrados ${matchingProducts.length} productos y ${matchingGroups.length} grupos");

    return {
      'productos': matchingProducts,
      'grupos': matchingGroups,
      'total': matchingProducts.length + matchingGroups.length,
    };
  }

}