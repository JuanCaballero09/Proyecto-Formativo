class Categoria {
  final int id;
  final String nombre;
  final String? descripcion;
  final String? imagenUrl;
  final int productCount;

  Categoria({
    required this.id,
    required this.nombre,
    this.descripcion,
    this.imagenUrl,
    this.productCount = 0,
  });

  factory Categoria.fromJson(Map<String, dynamic> json) {
    print('🔍 DEBUG Categoria.fromJson - JSON recibido: $json');
    
    // Extraer la URL de la imagen de forma segura
    String? imageUrl;
    
    // Intentar obtener la imagen desde diferentes campos posibles
    final imageField = json['imagen_url'] ?? 
                      json['image_url'] ?? 
                      json['imagen'] ?? 
                      json['image'];
    
    if (imageField != null) {
      if (imageField is String) {
        imageUrl = imageField;
        print('✅ Imagen encontrada (String): $imageUrl');
      } else if (imageField is Map) {
        // Si es un objeto, intentar extraer la URL
        imageUrl = imageField['url']?.toString();
        print('✅ Imagen encontrada (Map): $imageUrl');
      }
    } else {
      print('⚠️ No se encontró imagen para la categoría ${json['nombre'] ?? json['name']}');
    }

    final categoria = Categoria(
      id: json['id'] as int,
      nombre: json['nombre'] as String? ?? json['name'] as String? ?? 'Sin nombre',
      descripcion: json['descripcion'] as String?,
      imagenUrl: imageUrl,
      productCount: json['product_count'] as int? ?? 
                   json['productos_count'] as int? ?? 
                   json['products_count'] as int? ?? 
                   0,
    );
    
    print('✅ Categoría creada: $categoria');
    return categoria;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'imagen_url': imagenUrl,
      'product_count': productCount,
    };
  }

  // Método helper para obtener una imagen por defecto basada en el nombre
  String getDefaultImage() {
    final nombreLower = nombre.toLowerCase();
    
    print('🔍 Buscando imagen por defecto para: "$nombre" (normalizado: "$nombreLower")');
    
    // Buscar patrones específicos en el nombre (considerando emojis)
    if (nombreLower.contains('pizza')) {
      print('✅ Imagen encontrada: Pizza Hawiana.jpg');
      return 'assets/Pizza Hawiana.jpg';
    } else if (nombreLower.contains('hamburguesa') || nombreLower.contains('burger')) {
      print('✅ Imagen encontrada: Hamburgesa Doble Queso.jpeg');
      return 'assets/Hamburgesa Doble Queso.jpeg';
    } else if (nombreLower.contains('salchipapa')) {
      print('✅ Imagen encontrada: imagen1.jpeg');
      return 'assets/imagen1.jpeg';
    } else if (nombreLower.contains('taco')) {
      print('✅ Imagen encontrada: Tacos al Pastor.jpg');
      return 'assets/Tacos al Pastor.jpg';
    } else if (nombreLower.contains('ensalada') || nombreLower.contains('salad')) {
      print('✅ Imagen encontrada: Ensalada Cesar.jpg');
      return 'assets/Ensalada Cesar.jpg';
    } else if (nombreLower.contains('bebida') || nombreLower.contains('drink')) {
      print('✅ Imagen encontrada: bebida.jpg');
      return 'assets/bebida.jpg';
    } else if (nombreLower.contains('postre') || nombreLower.contains('dessert')) {
      print('✅ Imagen encontrada: imagen2.jpeg');
      return 'assets/imagen2.jpeg';
    }
    
    print('⚠️ No se encontró imagen específica, usando logoredondo.png');
    return 'assets/logoredondo.png'; // Imagen por defecto
  }

  @override
  String toString() {
    return 'Categoria(id: $id, nombre: $nombre, imagenUrl: $imagenUrl, productCount: $productCount)';
  }
}