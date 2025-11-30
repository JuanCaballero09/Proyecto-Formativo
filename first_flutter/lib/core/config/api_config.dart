/// Configuración centralizada para las URLs de la API
class ApiConfig {
  /// ⚠️ IMPORTANTE: Configuración de URL según plataforma
  /// - Web/iOS Simulator: usa "http://localhost:3000/api/v1"
  /// - Android Emulator: usa "http://10.0.2.2:3000/api/v1"
  /// - Dispositivo físico: usa "http://TU_IP:3000/api/v1" (ej: "http://192.168.1.10:3000/api/v1")
  
  /// URL base de la API
  /// 🔧 CAMBIA ESTA URL según tu plataforma (ver comentario arriba)
  static const String baseUrl = "http://10.0.2.2:3000/api/v1";

  /// Configuración de timeouts para las peticiones HTTP
  static const Duration connectionTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  /// Headers comunes para todas las peticiones
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Versión de la API
  static const String apiVersion = 'v1';

  /// Endpoints específicos
  static const String loginEndpoint = '/login';
  static const String logoutEndpoint = '/logout';
  // Backend usa path "categorias" para el recurso grupos
  static const String categoriesEndpoint = '/categorias';
  static const String ordersEndpoint = '/orders';
  static const String bannersEndpoint = '/banners';
  
  /// Construye la URL completa para productos por categoría
  /// [categoryId] - ID de la categoría
  static String getProductsByCategoryUrl(int categoryId) {
    return '$baseUrl$categoriesEndpoint/$categoryId/productos/';
  }

  /// Construye la URL completa para un producto específico
  /// [categoryId] - ID de la categoría
  /// [productId] - ID del producto
  static String getProductByIdUrl(int categoryId, int productId) {
    return '$baseUrl$categoriesEndpoint/$categoryId/productos/$productId';
  }

  /// Obtiene la URL completa para login
  static String get loginUrl => '$baseUrl$loginEndpoint';

  /// Obtiene la URL completa para logout
  static String get logoutUrl => '$baseUrl$logoutEndpoint';

  /// Obtiene la URL completa para banners
  static String get bannersUrl => '$baseUrl$bannersEndpoint';

  /// Obtiene la URL completa para órdenes
  static String get ordersUrl => '$baseUrl$ordersEndpoint';

  /// Construye la URL para una orden específica
  static String getOrderUrl(String code) {
    return '$baseUrl$ordersEndpoint/$code';
  }

  /// Construye la URL para cancelar una orden
  static String getCancelOrderUrl(String code) {
    return '$baseUrl$ordersEndpoint/$code/cancel';
  }
}