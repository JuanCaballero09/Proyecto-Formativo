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
    // Buscar el campo de imagen en múltiples posibles nombres
    String? imagenEncontrada;
    final posiblesCamposImagen = [
      'imagen_url',    // Tu API usa este campo
      'imagen', 'image', 'img', 'picture', 'photo', 'url', 'src', 
      'thumbnail', 'avatar', 'icon', 'logo', 'path'
    ];
    
    for (String campo in posiblesCamposImagen) {
      if (json[campo] != null && json[campo].toString().isNotEmpty) {
        imagenEncontrada = json[campo].toString();
        break;
      }
    }
    
    return Categoria(
      id: json['id'] ?? json['ID'] ?? 0,
      name: json['nombre'] ?? json['name'] ?? json['titulo'] ?? json['title'] ?? '',
      imagen: imagenEncontrada,
      descripcion: json['descripcion'] ?? json['description'] ?? json['desc'],
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