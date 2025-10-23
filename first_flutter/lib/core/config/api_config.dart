/// Configuración centralizada para las URLs de la API
/// Permite cambiar fácilmente entre diferentes entornos
class ApiConfig {
  /// URL base por defecto para desarrollo local
  static const String _defaultBaseUrl = "http://localhost:3000/api/v1";
  
  /// URL base para producción (cambiar según necesidades)
  static const String _productionBaseUrl = "https://api.tudominio.com/api/v1";
  
  /// URL base para staging/pruebas
  static const String _stagingBaseUrl = "https://api-staging.tudominio.com/api/v1";

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
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

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
}