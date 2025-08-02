import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'product_repository.dart';

class MockiProductRepository implements ProductRepository {
  final String endpointUrl;
  MockiProductRepository({this.endpointUrl = 'https://mocki.io/v1/215c5711-cce0-459c-bea1-3b7fead1b4be'});

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
