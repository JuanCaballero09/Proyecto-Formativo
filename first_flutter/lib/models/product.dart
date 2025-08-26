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
    List<String> ingredientsList = [];
    if (json['ingredientes'] != null) {
      if (json['ingredientes'] is String) {
        ingredientsList = (json['ingredientes'] as String)
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else if (json['ingredientes'] is List) {
        ingredientsList = List<String>.from(json['ingredientes']);
      }
    }
    
    return Product(
      id: json['id'] ?? 0,
      name: json['nombre'] ?? '',
      category: json['categoria'] ?? 'General',
      price: (json['precio'] as num?)?.toDouble() ?? 0.0,
      description: json['descripcion'] ?? '',
      image: json['imagen_url'] ?? '',
      ingredients: ingredientsList,
    );
  }

  @override
  List<Object?> get props => [id, name, category, price, description, image, ingredients];
}
