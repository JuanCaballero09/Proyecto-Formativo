/// Configuración centralizada para las URLs de la API
/// Permite cambiar fácilmente entre diferentes entornos
class ApiConfig {
  /// ⚠️ IMPORTANTE: Configuración de URL según plataforma
  /// - Web/iOS Simulator: usa "http://localhost:3000/api/v1"
  /// - Android Emulator: usa "http://10.0.2.2:3000/api/v1"
  /// - Dispositivo físico: usa "http://TU_IP:3000/api/v1" (ej: "http://192.168.1.10:3000/api/v1")
  
  /// URL base por defecto para desarrollo local
  /// 🔧 CAMBIA ESTA URL según tu plataforma (ver comentario arriba)
  static const String _defaultBaseUrl = "https://whole-tahr-stunning.ngrok-free.app/api/v1";
  
  /// URL base para producción (cambiar según necesidades)
  static const String _productionBaseUrl = "https://api.tudominio.com/api/v1";
  
  /// URL base para staging/pruebas
  // static const String _stagingBaseUrl = "https://api-staging.tudominio.com/api/v1";

  /// Indica si estamos en modo desarrollo
  static const bool _isDevelopment = true; // Cambiar a false para producción

  /// Obtiene la URL base según el entorno
  static String get baseUrl {
    if (_isDevelopment) {
      return _defaultBaseUrl;
    } else {
      return _productionBaseUrl; // Usar staging si es necesario: _stagingBaseUrl
    }
  }

  /// Permite override manual de la URL base
  /// Útil para pruebas o configuraciones especiales
  static String? _overrideBaseUrl;

  /// Establece una URL base personalizada
  /// [url] - URL base personalizada
  static void setBaseUrl(String url) {
    _overrideBaseUrl = url;
  }

  /// Resetea la URL base a la configuración por defecto
  static void resetBaseUrl() {
    _overrideBaseUrl = null;
  }

  /// Obtiene la URL base actual (considera override si existe)
  static String get currentBaseUrl {
    return _overrideBaseUrl ?? baseUrl;
  }

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
  
  /// Construye la URL completa para productos por categoría
  /// [categoryId] - ID de la categoría
  static String getProductsByCategoryUrl(int categoryId) {
    return '$currentBaseUrl$categoriesEndpoint/$categoryId/productos/';
  }

  /// Construye la URL completa para un producto específico
  /// [categoryId] - ID de la categoría
  /// [productId] - ID del producto
  static String getProductByIdUrl(int categoryId, int productId) {
    return '$currentBaseUrl$categoriesEndpoint/$categoryId/productos/$productId';
  }

  /// Obtiene la URL completa para login
  static String get loginUrl => '$currentBaseUrl$loginEndpoint';

  /// Obtiene la URL completa para logout
  static String get logoutUrl => '$currentBaseUrl$logoutEndpoint';

  /// Obtiene la URL completa para órdenes
  static String get ordersUrl => '$currentBaseUrl$ordersEndpoint';

  /// Construye la URL para una orden específica
  static String getOrderUrl(String code) {
    return '$currentBaseUrl$ordersEndpoint/$code';
  }

  /// Construye la URL para cancelar una orden
  static String getCancelOrderUrl(String code) {
    return '$currentBaseUrl$ordersEndpoint/$code/cancel';
  }
}