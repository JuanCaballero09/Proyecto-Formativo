import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/product.dart';
import 'product_repository.dart';

class HttpProductRepository implements ProductRepository {
  final String apiUrl;

  HttpProductRepository({required this.apiUrl});

  @override
  Future<List<Product>> getProductsByCategory(String categoryName) async {
    // La API de mocki.io no soporta filtrado por categoría,
    // así que cargamos todos y filtramos en el cliente.
    final allProducts = await getProducts();
    return allProducts.where((p) => p.category.toLowerCase() == categoryName.toLowerCase()).toList();
  }

  @override
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
