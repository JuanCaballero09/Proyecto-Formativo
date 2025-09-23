import '../models/product.dart';
import '../service/ApiService.dart';
import 'product_repository.dart';

/// Repositorio para el consumo de productos desde la API REST
/// Implementa los métodos definidos en ProductRepository usando ApiService
class ApiProductRepository implements ProductRepository {
  /// Servicio API que maneja las peticiones HTTP
  final ApiService _apiService;

  /// Constructor que permite inyectar la dependencia del ApiService
  /// [apiService] - Instancia del servicio API (opcional, se crea una por defecto)
  ApiProductRepository({ApiService? apiService}) 
    : _apiService = apiService ?? ApiService();

  /// Constructor con URL base personalizada
  /// [baseUrl] - URL base de la API
  ApiProductRepository.withBaseUrl(String baseUrl) 
    : _apiService = ApiService(baseUrl: baseUrl);

  @override
  Future<List<Product>> getProducts() async {
    try {
      // Para obtener todos los productos, consultar todas las categorías (1, 2, 3)
      final List<Product> allProducts = [];
      
      // Obtener productos de cada categoría
      for (int categoryId = 1; categoryId <= 3; categoryId++) {
        try {
          final categoryProducts = await _apiService.getProductsByCategory(categoryId);
          allProducts.addAll(categoryProducts);
        } catch (e) {
          // Si falla una categoría, continuar con las demás
          // ignore: avoid_print
          print("⚠️ Error al obtener productos de categoría $categoryId: $e");
        }
      }
      
      // ignore: avoid_print
      print("✅ Total de productos obtenidos: ${allProducts.length}");
      return allProducts;

    } catch (e) {
      // ignore: avoid_print
      print("❌ Error al obtener todos los productos: $e");
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryName) async {
    try {
      // Mapear nombres de categorías a IDs
      final int categoryId = _getCategoryIdFromName(categoryName);
      
      // Obtener productos usando el ID de categoría
      final products = await _apiService.getProductsByCategory(categoryId);
      
      // ignore: avoid_print
      print("✅ Productos obtenidos para categoría '$categoryName': ${products.length}");
      return products;

    } catch (e) {
      // ignore: avoid_print
      print("❌ Error al obtener productos de categoría '$categoryName': $e");
      rethrow;
    }
  }

  /// Obtiene productos por ID de categoría directamente (método específico de API)
  /// [categoryId] - ID de la categoría (1, 2 o 3)
  Future<List<Product>> getProductsByCategoryId(int categoryId) async {
    try {
      final products = await _apiService.getProductsByCategory(categoryId);
      
      // ignore: avoid_print
      print("✅ Productos obtenidos para categoría ID $categoryId: ${products.length}");
      return products;

    } catch (e) {
      // ignore: avoid_print
      print("❌ Error al obtener productos de categoría ID $categoryId: $e");
      rethrow;
    }
  }

  /// Obtiene un producto específico por IDs de categoría y producto (método específico de API)
  /// [categoryId] - ID de la categoría (1, 2 o 3)
  /// [productId] - ID del producto (1, 2 o 3)
  Future<Product> getProductByCategoryIdAndProductId(int categoryId, int productId) async {
    try {
      final product = await _apiService.getProductByCategoryAndId(categoryId, productId);
      
      // ignore: avoid_print
      print("✅ Producto específico obtenido: ${product.name}");
      return product;

    } catch (e) {
      // ignore: avoid_print
      print("❌ Error al obtener producto $productId de categoría ID $categoryId: $e");
      rethrow;
    }
  }

  /// Obtiene un producto específico por categoría e ID
  /// [categoryName] - Nombre de la categoría
  /// [productId] - ID del producto (1, 2 o 3)
  Future<Product> getProductByCategoryAndId(String categoryName, int productId) async {
    try {
      // Mapear nombre de categoría a ID
      final int categoryId = _getCategoryIdFromName(categoryName);
      
      // Obtener producto específico
      final product = await _apiService.getProductByCategoryAndId(categoryId, productId);
      
      // ignore: avoid_print
      print("✅ Producto específico obtenido: ${product.name}");
      return product;

    } catch (e) {
      // ignore: avoid_print
      print("❌ Error al obtener producto $productId de categoría '$categoryName': $e");
      rethrow;
    }
  }

  /// Mapea nombres de categorías a IDs de la API
  /// [categoryName] - Nombre de la categoría
  /// Retorna el ID correspondiente de la categoría
  int _getCategoryIdFromName(String categoryName) {
    final String normalizedName = categoryName.toLowerCase().trim();
    
    // Mapeo de nombres de categorías a IDs según la API
    switch (normalizedName) {
      case 'hamburguesas':
      case 'burgers':
      case 'hamburgesas': // Por si hay variaciones en el nombre
        return 1;
      
      case 'salchipapas':
      case 'salchipapa':
        return 2;
      
      case 'pizzas':
      case 'pizza':
        return 3;
      
      // Categorías adicionales que pueden existir en la UI
      case 'tacos':
      case 'taco':
        // Por ahora mapear tacos a hamburguesas (ID 1)
        // TODO: Actualizar cuando exista endpoint específico para tacos
        return 1;
      
      case 'ensaladas':
      case 'salads':
      case 'ensalada':
        // Por ahora mapear ensaladas a salchipapas (ID 2)
        // TODO: Actualizar cuando exista endpoint específico para ensaladas
        return 2;
      
      default:
        // ignore: avoid_print
        print("⚠️ Categoría desconocida: '$categoryName', usando categoría por defecto (1)");
        return 1; // Categoria por defecto: hamburguesas
    }
  }
}