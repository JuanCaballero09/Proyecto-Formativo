import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final int id;
  final String name;
  final double price;
  final String description;
  final String image;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.image,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    String imageUrl = (json['imagen_url'] ?? '').replaceFirst('localhost', '192.168.1.69');

    
    return Product(
      id: json['id'] ?? 0,
      name: json['nombre'] ?? '',
      price: json['precio'] ?? 0.0,
      description: json['descripcion'] ?? '',
      image: json['imagen_url'] ?? '',
    );
  }

  @override
  List<Object?> get props => [id, name, price, description, image];
}
