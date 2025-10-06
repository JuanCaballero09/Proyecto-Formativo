import 'package:equatable/equatable.dart';

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
        ingredientsList = ingredientsField
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else if (ingredientsField is List) {
        ingredientsList = List<String>.from(ingredientsField);
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
    
    // Map grupo_id to category names
    String category = json['category'] ?? json['categoria'] ?? 'General';
    if (category == 'General' && json['grupo_id'] != null) {
      switch (json['grupo_id']) {
        case 1:
          category = 'hamburguesas';
          break;
        case 2:
          category = 'salchipapas';
          break;
        case 3:
          category = 'pizzas';
          break;
        default:
          category = 'General';
      }
    }
    
    final producto = Product(
      id: productId,
      name: json['name'] ?? json['nombre'] ?? '',
      category: category,
      price: productPrice,
      description: json['description'] ?? json['descripcion'] ?? '',
      image: json['image'] ?? json['imagen'] ?? json['imagen_url'] ?? '',
      ingredients: ingredientsList,
    );
    
    print('Producto creado: ID=${producto.id}, Nombre=${producto.name}, Categoría=${producto.category}');
    print('================================');
    
    return producto;
  }

  @override
  List<Object?> get props => [id, name, category, price, description, image, ingredients];
}
