import 'package:equatable/equatable.dart';
import '../core/config/api_config.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final String category;
  final double price;
  final String description;
  final String image;
  final List<String> ingredients; 

  const Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.description,
    required this.image,
    this.ingredients = const [],
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Debug: Ver qué datos vienen del JSON
    print('=== DEBUG: Product.fromJson ===');
    print('JSON recibido: $json');
    
    List<String> ingredientsList = [];
    
    // Check for ingredients in both languages and formats
    final ingredientsField = json['ingredientes'] ?? json['ingredients'];
    if (ingredientsField != null) {
      if (ingredientsField is String) {
        // Si es un String, dividir por comas
        ingredientsList = ingredientsField
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else if (ingredientsField is List) {
        // Si es una lista, puede contener Strings o Maps
        ingredientsList = ingredientsField.map((item) {
          if (item is String) {
            return item;
          } else if (item is Map) {
            // Si es un Map, extraer el campo 'nombre'
            return (item['nombre'] ?? item['name'] ?? '').toString();
          }
          return item.toString();
        }).where((e) => e.isNotEmpty).toList();
      }
    }
    
    // Handle ID conversion
    int productId;
    if (json['id'] is String) {
      productId = int.tryParse(json['id']) ?? 0;
    } else {
      productId = json['id'] ?? 0;
    }
    
    // Handle price conversion
    double productPrice;
    final priceField = json['price'] ?? json['precio'] ?? 0;
    if (priceField is String) {
      productPrice = double.tryParse(priceField) ?? 0.0;
    } else {
      productPrice = (priceField as num).toDouble();
    }
    
    // Map categoria_id to category names (transformado desde grupo_id)
    String category = json['category'] ?? json['categoria'] ?? 'General';
    if (category == 'General' && json['categoria_id'] != null) {
      switch (json['categoria_id']) {
        case 1:
          category = 'hamburguesas';
          break;
        case 2:
          category = 'salchipapas';
          break;
        case 3:
          category = 'pizzas';
          break;
        case 4:
          category = 'bebidas';
          break;
        case 5:
          category = 'postres';
          break;
        default:
          category = 'General';
      }
    }
    
    // Handle image URL - agregar base URL si es una ruta relativa
    String imageUrl = json['image'] ?? json['imagen'] ?? json['imagen_url'] ?? '';
    if (imageUrl.isNotEmpty && !imageUrl.startsWith('http')) {
      // Es una ruta relativa, agregar base URL
      // Remover /api/v1 del baseUrl para obtener solo el dominio
      final baseUrlWithoutApi = ApiConfig.baseUrl.replaceAll('/api/v1', '');
      imageUrl = '$baseUrlWithoutApi$imageUrl';
    }
    
    final producto = Product(
      id: productId,
      name: json['name'] ?? json['nombre'] ?? '',
      category: category,
      price: productPrice,
      description: json['description'] ?? json['descripcion'] ?? '',
      image: imageUrl,
      ingredients: ingredientsList,
    );
    
    print('Producto creado: ID=${producto.id}, Nombre=${producto.name}, Categoría=${producto.category}');
    print('Imagen URL: ${producto.image}');
    print('================================');
    
    return producto;
  }

  @override
  List<Object?> get props => [id, name, category, price, description, image, ingredients];
}
