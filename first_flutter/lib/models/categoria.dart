class Categoria {
  final int id;
  final String name;
  final String? imagen;
  final String? descripcion;

  Categoria({
    required this.id,
    required this.name,
    this.imagen,
    this.descripcion,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      id: json['id'] ?? 0,
      name: json['name'] ?? json['nombre'] ?? '',
      imagen: json['imagen'] ?? json['image'],
      descripcion: json['descripcion'] ?? json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imagen': imagen,
      'descripcion': descripcion,
    };
  }

  @override
  String toString() {
    return 'Categoria{id: $id, name: $name, imagen: $imagen, descripcion: $descripcion}';
  }
}