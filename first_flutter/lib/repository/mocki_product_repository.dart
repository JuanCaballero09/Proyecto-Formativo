import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'product_repository.dart';

class MockiProductRepository implements ProductRepository {
  final String endpointUrl;
  MockiProductRepository({this.endpointUrl = 'http://localhost:3000/api/v1/products'});

  @override
  Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(endpointUrl));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(
        utf8.decode(response.bodyBytes),
      );
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
