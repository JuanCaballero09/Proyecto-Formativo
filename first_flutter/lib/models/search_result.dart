/// Modelo para representar un resultado de búsqueda
/// Puede ser un producto o una categoría
class SearchResult {
  final String id;
  final String name;
  final String type; // 'product' o 'category'
  final String? image;
  final double? price;
  final String? description;
  final Map<String, dynamic>? rawData; // Guardar los datos completos del JSON

  SearchResult({
    required this.id,
    required this.name,
    required this.type,
    this.image,
    this.price,
    this.description,
    this.rawData,
  });

  /// Crea un SearchResult desde JSON de producto
  factory SearchResult.fromProductJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id']?.toString() ?? '',
      name: json['nombre'] ?? json['name'] ?? 'Sin nombre',
      type: 'product',
      image: json['imagen_url'] ?? json['image'],
      price: _parsePrice(json['precio'] ?? json['price']),
      description: json['descripcion'] ?? json['description'],
      rawData: json, // Guardar JSON completo
    );
  }

  /// Crea un SearchResult desde JSON de categoría
  factory SearchResult.fromCategoryJson(Map<String, dynamic> json) {
    return SearchResult(
      id: json['id']?.toString() ?? '',
      name: json['nombre'] ?? json['name'] ?? 'Sin nombre',
      type: 'category',
      image: json['imagen_url'] ?? json['image'],
      price: null,
      description: json['descripcion'] ?? json['description'],
      rawData: json, // Guardar JSON completo
    );
  }

  /// Parsea el precio de forma segura
  static double? _parsePrice(dynamic price) {
    if (price == null) return null;
    if (price is double) return price;
    if (price is int) return price.toDouble();
    if (price is String) {
      return double.tryParse(price);
    }
    return null;
  }

  /// Convierte el SearchResult a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'image': image,
      'price': price,
      'description': description,
      'rawData': rawData,
    };
  }

  @override
  String toString() {
    return 'SearchResult(id: $id, name: $name, type: $type, price: $price)';
  }
}
