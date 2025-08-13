import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final double price;
  final String description;
  final String image;
  final List<String> ingredients; // Nuevo campo para ingredientes

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
    this.ingredients = const [], // Lista vacía por defecto
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Procesamos los ingredientes desde el JSON
    List<String> ingredientsList = [];
    if (json['ingredientes'] != null) {
      if (json['ingredientes'] is String) {
        // Si viene como string separado por comas
        ingredientsList = (json['ingredientes'] as String)
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else if (json['ingredientes'] is List) {
        // Si viene como lista
        ingredientsList = List<String>.from(json['ingredientes']);
      }
    }
    
    return Product(
      id: json['id'] ?? 0,
      name: json['nombre'] ?? '',
      price: json['precio'] ?? 0.0,
      description: json['descripcion'] ?? '',
      image: json['imagen_url'] ?? '',
      ingredients: ingredientsList,
    );
  }

  @override
  List<Object?> get props => [id, name, price, description, image, ingredients];
}
