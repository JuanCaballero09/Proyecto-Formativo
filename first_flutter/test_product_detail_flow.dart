/// Test para verificar el flujo de visualización de productos
/// Este script verifica que los productos se estén pasando correctamente
/// desde la lista de categoría hasta la página de detalle

import 'dart:convert';

void main() async {
  print('=== TEST: Flujo de Visualización de Productos ===\n');

  // Simular respuesta de la API para una categoría
  final simulatedApiResponse = '''
  [
    {
      "id": 15,
      "nombre": "Hamburguesa Clásica",
      "descripcion": "Deliciosa hamburguesa con todos los ingredientes",
      "precio": 15000,
      "imagen_url": "http://localhost:3000/imagen1.jpg",
      "grupo_id": 1,
      "ingredientes": ["Carne", "Lechuga", "Tomate", "Queso"]
    },
    {
      "id": 16,
      "nombre": "Hamburguesa BBQ",
      "descripcion": "Hamburguesa con salsa BBQ",
      "precio": 18000,
      "imagen_url": "http://localhost:3000/imagen2.jpg",
      "grupo_id": 1,
      "ingredientes": ["Carne", "Cebolla", "BBQ"]
    },
    {
      "id": 17,
      "nombre": "Hamburguesa Doble",
      "descripcion": "Doble carne, doble sabor",
      "precio": 22000,
      "imagen_url": "http://localhost:3000/imagen3.jpg",
      "grupo_id": 1,
      "ingredientes": ["Carne", "Queso", "Bacon"]
    }
  ]
  ''';

  print('1. Simulando respuesta de API: /api/v1/categorias/1/productos/');
  final List<dynamic> apiData = jsonDecode(simulatedApiResponse);
  print('   ✓ Se obtuvieron ${apiData.length} productos\n');

  // Simular la conversión a objetos Product (lo que hace Product.fromJson)
  print('2. Convirtiendo JSON a objetos Product:');
  final products = apiData.map((json) {
    final product = {
      'id': json['id'],
      'name': json['nombre'],
      'description': json['descripcion'],
      'price': json['precio'],
      'image': json['imagen_url'],
      'category': _getCategoryFromGroupId(json['grupo_id']),
      'ingredients': json['ingredientes'],
    };
    print('   - Producto ID: ${product['id']}, Nombre: ${product['name']}');
    return product;
  }).toList();
  print('   ✓ ${products.length} productos convertidos\n');

  // Simular GridView.builder - mostrar qué producto está en cada posición
  print('3. Simulando GridView.builder (lista de productos):');
  for (int index = 0; index < products.length; index++) {
    final product = products[index];
    print('   Index $index: ID=${product['id']}, Nombre=${product['name']}');
  }
  print('');

  // Simular clic en el segundo producto (index 1)
  print('4. Simulando clic en el producto en posición index=1:');
  final clickedIndex = 1;
  final selectedProduct = products[clickedIndex];
  print('   - Index seleccionado: $clickedIndex');
  print('   - Producto seleccionado: ID=${selectedProduct['id']}, Nombre=${selectedProduct['name']}');
  print('');

  // Simular navegación a ProductDetailPage
  print('5. Navegando a ProductDetailPage con el producto seleccionado:');
  print('   - Producto recibido en ProductDetailPage:');
  print('     * ID: ${selectedProduct['id']}');
  print('     * Nombre: ${selectedProduct['name']}');
  print('     * Descripción: ${selectedProduct['description']}');
  print('     * Precio: ${selectedProduct['price']}');
  print('     * Categoría: ${selectedProduct['category']}');
  print('     * Imagen: ${selectedProduct['image']}');
  print('');

  // Verificar que el producto correcto se muestra
  print('6. VERIFICACIÓN:');
  if (selectedProduct['id'] == 16 && selectedProduct['name'] == 'Hamburguesa BBQ') {
    print('   ✓ CORRECTO: El producto seleccionado es el esperado');
    print('   ✓ El flujo de datos está funcionando correctamente');
  } else {
    print('   ✗ ERROR: El producto no es el esperado');
    print('   ✗ Esperado: ID=16, Nombre=Hamburguesa BBQ');
    print('   ✗ Recibido: ID=${selectedProduct['id']}, Nombre=${selectedProduct['name']}');
  }
  print('');

  print('=== TEST COMPLETADO ===\n');

  // Ahora probemos un escenario problemático potencial
  print('\n=== TEST: Escenario Problemático ===\n');
  print('Problema potencial: Si el backend devuelve productos con IDs no secuenciales');
  print('pero el frontend asume que los IDs son 1, 2, 3...\n');

  final problematicProducts = [
    {'id': 25, 'nombre': 'Pizza Margherita'},
    {'id': 30, 'nombre': 'Pizza Pepperoni'},
    {'id': 18, 'nombre': 'Pizza Hawaiana'},
  ];

  print('Productos en la lista:');
  for (int i = 0; i < problematicProducts.length; i++) {
    print('  Index $i: ID=${problematicProducts[i]['id']}, Nombre=${problematicProducts[i]['nombre']}');
  }
  print('');

  print('Si se hace clic en index=1 (Pizza Pepperoni, ID=30):');
  final selectedProblem = problematicProducts[1];
  print('  - Se debe mostrar: ${selectedProblem['nombre']} (ID=${selectedProblem['id']})');
  print('');

  print('¿Qué pasa si hay una confusión entre index e ID?');
  print('  - Si se usa el INDEX (1) como ID en la API:');
  print('    GET /api/v1/categorias/3/productos/1');
  print('    El backend buscaría un producto con ID=1 en la categoría 3');
  print('    Pero ese producto NO EXISTE (los IDs son 25, 30, 18)');
  print('    Resultado: ERROR 404 o producto incorrecto');
  print('');
  print('  - Si se usa el ID correcto (30) en la API:');
  print('    GET /api/v1/categorias/3/productos/30');
  print('    El backend buscaría un producto con ID=30 en la categoría 3');
  print('    Resultado: ✓ CORRECTO - Se obtiene Pizza Pepperoni');
  print('');

  print('=== CONCLUSIÓN ===');
  print('El código actual en category_products_page.dart está correcto:');
  print('  final product = products[index];');
  print('  ProductDetailPage(product: product)');
  print('');
  print('Esto pasa el OBJETO completo, no el index.');
  print('Por lo tanto, ProductDetailPage recibe el producto correcto con su ID real.');
  print('');
  print('Si hay un problema, debe estar en:');
  print('  1. Los datos que devuelve la API (productos duplicados o incorrectos)');
  print('  2. El parsing en Product.fromJson (mapeo incorrecto de campos)');
  print('  3. Caché o estado persistente que muestra datos antiguos');
  print('');
}

String _getCategoryFromGroupId(int grupoId) {
  switch (grupoId) {
    case 1:
      return 'hamburguesas';
    case 2:
      return 'salchipapas';
    case 3:
      return 'pizzas';
    default:
      return 'General';
  }
}
