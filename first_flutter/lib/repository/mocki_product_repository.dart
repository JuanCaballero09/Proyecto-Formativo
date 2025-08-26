import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'product_repository.dart';

class MockiProductRepository implements ProductRepository {
  final String endpointUrl;
  MockiProductRepository({this.endpointUrl = 'http://localhost:3000/api/v1/products'});

  @override
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse(endpointUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(
          utf8.decode(response.bodyBytes),
        );
        
        final products = data.map((json) => Product.fromJson(json)).toList();
        return products;
      } else {
        throw Exception('Failed to load products: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryName) async {
    try {
      // Map category names from UI to internal categories
      String internalCategory = _mapToInternalCategory(categoryName);
      
      final allProducts = await getProducts();
      
      final filteredProducts = allProducts.where((product) {
        final productCategory = product.category.toLowerCase();
        final searchCategory = internalCategory.toLowerCase();
        return productCategory == searchCategory;
      }).toList();
      
      return filteredProducts;
    } catch (e) {
      rethrow;
    }
  }
  
  String _mapToInternalCategory(String categoryName) {
    final name = categoryName.toLowerCase();
    
    // Map both English and Spanish category names to internal categories
    switch (name) {
      // Hamburgers mapping
      case 'hamburguesas':
      case 'burgers':
      case 'hamburgers':
        return 'hamburguesas';
        
      // Pizzas mapping
      case 'pizzas':
        return 'pizzas';
        
      // Salchipapas mapping
      case 'salchipapa':
      case 'salchipapas':
        return 'salchipapas';
        
      // Tacos mapping
      case 'tacos':
        return 'tacos';
        
      // Salads mapping  
      case 'ensaladas':
      case 'salads':
        return 'ensaladas';
        
      default:
        return name;
    }
  }
}
