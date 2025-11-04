import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../core/errors/exceptions.dart';
import '../core/config/api_config.dart';

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

  /// 🔄 Función auxiliar para transformar JSON: grupo → categoria
  /// Transforma grupo_id → categoria_id y grupo → categoria
  Map<String, dynamic> _transformJsonToCategoria(Map<String, dynamic> json) {
    final transformed = Map<String, dynamic>.from(json);
    
    // Transformar grupo_id → categoria_id
    if (json.containsKey('grupo_id')) {
      transformed['categoria_id'] = json['grupo_id'];
      transformed.remove('grupo_id');
    }
    
    // Transformar grupo → categoria
    if (json.containsKey('grupo')) {
      transformed['categoria'] = json['grupo'];
      transformed.remove('grupo');
    }
    
    return transformed;
  }

  /// 🔄 Transformar lista de productos/categorías
  List<dynamic> _transformList(List<dynamic> items) {
    return items.map((item) {
      if (item is Map<String, dynamic>) {
        return _transformJsonToCategoria(item);
      }
      return item;
    }).toList();
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
    if (categoryId < 1) {
      throw DataException('ID de categoría inválido. Debe ser mayor a 0');
    }

    try {
      final url = Uri.parse(ApiConfig.getProductsByCategoryUrl(categoryId));
      final headers = await _getAuthHeaders();

      // ignore: avoid_print
      print("🔍 Obteniendo productos de categoría $categoryId desde: $url");

      final response = await http
          .get(url, headers: headers)
          .timeout(ApiConfig.receiveTimeout);
      
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

      // 🔄 TRANSFORMAR: grupo_id → categoria_id
      final transformedList = _transformList(productsJson);
      final products = transformedList.map((json) => Product.fromJson(json)).toList();
      
      // ignore: avoid_print
      print("✅ ${products.length} productos obtenidos de categoría $categoryId");
      return products;

    } on TimeoutException {
      // ignore: avoid_print
      print("⏱️ Timeout al obtener productos de categoría $categoryId");
      throw NetworkException('La petición tardó demasiado. Verifica tu conexión y que el servidor esté funcionando.');
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
  /// [categoryId] - ID de la categoría (grupo)
  /// [productId] - ID del producto
  /// Retorna el producto solicitado
  Future<Product> getProductByCategoryAndId(int categoryId, int productId) async {
    if (categoryId < 1) {
      throw DataException('ID de categoría inválido. Debe ser mayor a 0');
    }

    // Eliminar la validación restrictiva del productId
    // Los productos pueden tener cualquier ID válido
    if (productId < 1) {
      throw DataException('ID de producto inválido. Debe ser mayor a 0');
    }

    try {
      final url = Uri.parse(ApiConfig.getProductByIdUrl(categoryId, productId));
      final headers = await _getAuthHeaders();

      // ignore: avoid_print
      print("🔍 Obteniendo producto $productId de categoría $categoryId desde: $url");

      final response = await http
          .get(url, headers: headers)
          .timeout(ApiConfig.receiveTimeout);
      
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

      // 🔄 TRANSFORMAR: grupo_id → categoria_id
      final transformedJson = _transformJsonToCategoria(productJson);
      final product = Product.fromJson(transformedJson);
      
      // ignore: avoid_print
      print("✅ Producto obtenido: ${product.name}");
      return product;

    } on TimeoutException {
      // ignore: avoid_print
      print("⏱️ Timeout al obtener producto $productId de categoría $categoryId");
      throw NetworkException('La petición tardó demasiado. Verifica tu conexión y que el servidor esté funcionando.');
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

    final response = await http
        .post(
          url,
          headers: ApiConfig.defaultHeaders,
          body: jsonEncode({
            'email': email, 
            'password': password,
          }),
        )
        .timeout(ApiConfig.connectionTimeout);

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
    final response = await http
        .post(
          url,
          headers: {
            'Authorization': token,
            ...ApiConfig.defaultHeaders,
          },
        )
        .timeout(ApiConfig.connectionTimeout);

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
    // Backend usa path "categorias" para el recurso grupos
    final url = Uri.parse('${baseUrl}/categorias');

    try {
      final response = await http
          .get(url)
          .timeout(ApiConfig.receiveTimeout);

      if(response.statusCode == 200){
        final List<dynamic> decoded = jsonDecode(response.body);
        
        // 🔄 TRANSFORMAR: grupo → categoria
        return _transformList(decoded);
      } else {
        // ignore: avoid_print
        print('❌ Error HTTP: ${response.statusCode}');
        return null;
      }
    } on TimeoutException {
      // ignore: avoid_print
      print('⏱️ Timeout al obtener categorías');
      return null;
    } catch (e) {
      // ignore: avoid_print
      print('❌ Error en getCategorias: $e');
      return null;
    }
  }

  /// Busca productos y categorías por query
  /// [query] - Texto de búsqueda
  /// Retorna un mapa con 'productos' y 'categorias' que coinciden con la búsqueda
  Future<Map<String, dynamic>> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      return {'productos': [], 'categorias': []};
    }

    try {
      final url = Uri.parse('$baseUrl/buscar?q=${Uri.encodeComponent(query)}');
      
      // No enviar token de autenticación para búsqueda (endpoint público)
      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      };

      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));

      _handleHttpResponse(response, 'búsqueda de productos');

      final data = jsonDecode(response.body);

      // 🔄 TRANSFORMAR: grupos → categorias y grupo_id → categoria_id
      return {
        'productos': _transformList(data['productos'] ?? []),
        'categorias': _transformList(data['grupos'] ?? data['categorias'] ?? []),
        'total': data['total'] ?? 0,
      };

    } on TimeoutException {
      // ignore: avoid_print
      print('⏱️ Timeout en búsqueda de productos');
      throw NetworkException('La búsqueda tardó demasiado. Verifica tu conexión.');
    } on NetworkException {
      rethrow;
    } on DataException {
      rethrow;
    } catch (e) {
      // ignore: avoid_print
      print('❌ Error en búsqueda: $e');
      throw NetworkException('Error de conexión al buscar productos');
    }
  }
}
