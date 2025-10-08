/// Test para verificar el mapeo de nombres de categorías
/// Este script simula diferentes nombres que podrían venir de la API
/// y verifica si se mapean correctamente a los IDs

void main() {
  print('=== TEST: Mapeo de Nombres de Categorías ===\n');

  // Casos de prueba
  final testCases = [
    // Formato esperado
    {'input': 'HAMBURGUESAS', 'expectedId': 1, 'expectedName': 'Hamburguesas'},
    {'input': 'PIZZAS', 'expectedId': 3, 'expectedName': 'Pizzas'},
    {'input': 'SALCHIPAPAS', 'expectedId': 2, 'expectedName': 'Salchipapas'},
    
    // Variaciones de formato
    {'input': 'hamburguesas', 'expectedId': 1, 'expectedName': 'Hamburguesas'},
    {'input': 'Hamburguesas', 'expectedId': 1, 'expectedName': 'Hamburguesas'},
    {'input': 'pizzas', 'expectedId': 3, 'expectedName': 'Pizzas'},
    {'input': 'Pizzas', 'expectedId': 3, 'expectedName': 'Pizzas'},
    
    // Nombres que podrían venir de la base de datos
    {'input': 'Hamburguesa', 'expectedId': null, 'expectedName': 'DESCONOCIDO'},
    {'input': 'Pizza', 'expectedId': 3, 'expectedName': 'Pizzas'},
    {'input': 'Salchipapa', 'expectedId': 2, 'expectedName': 'Salchipapas'},
    
    // Espacios y caracteres especiales
    {'input': '  HAMBURGUESAS  ', 'expectedId': 1, 'expectedName': 'Hamburguesas'},
    {'input': 'HAMBURGUESAS ', 'expectedId': 1, 'expectedName': 'Hamburguesas'},
    
    // Categorías no existentes
    {'input': 'TACOS', 'expectedId': 1, 'expectedName': 'Hamburguesas (fallback)'},
    {'input': 'ENSALADAS', 'expectedId': 2, 'expectedName': 'Salchipapas (fallback)'},
    {'input': 'BEBIDAS', 'expectedId': 1, 'expectedName': 'Hamburguesas (default)'},
  ];

  int passed = 0;
  int failed = 0;

  for (final testCase in testCases) {
    final input = testCase['input'] as String;
    final expectedId = testCase['expectedId'] as int?;
    
    final result = getCategoryIdFromName(input);
    final success = expectedId == null ? result == 1 : result == expectedId;
    
    if (success) {
      print('✓ "$input" → ID $result ${success ? "✓" : "✗"}');
      passed++;
    } else {
      print('✗ "$input" → ID $result (esperado: $expectedId) ✗');
      failed++;
    }
  }

  print('\n=== RESULTADOS ===');
  print('Total: ${testCases.length}');
  print('Exitosos: $passed');
  print('Fallidos: $failed');
  
  if (failed > 0) {
    print('\n⚠️ PROBLEMA DETECTADO:');
    print('Algunos nombres de categorías no se están mapeando correctamente.');
    print('Verifica que los nombres que vienen de la API coincidan exactamente');
    print('con los casos definidos en _getCategoryIdFromName().');
  } else {
    print('\n✓ Todos los casos de prueba pasaron correctamente.');
  }
  
  print('\n=== RECOMENDACIONES ===');
  print('1. Verifica qué nombres exactos vienen de la API en el campo "nombre"');
  print('2. Agrega prints en Categoria.fromJson() para ver los datos crudos');
  print('3. Si los nombres vienen diferentes (ej: "Hamburguesa" singular),');
  print('   agrega esos casos al switch en _getCategoryIdFromName()');
  print('4. Considera usar el ID de la categoría directamente en lugar del nombre');
}

int getCategoryIdFromName(String categoryName) {
  final String normalizedName = categoryName.toLowerCase().trim();
  
  switch (normalizedName) {
    case 'hamburguesas':
    case 'burgers':
    case 'hamburgesas':
      return 1;
    
    case 'salchipapas':
    case 'salchipapa':
      return 2;
    
    case 'pizzas':
    case 'pizza':
      return 3;
    
    case 'tacos':
    case 'taco':
      return 1; // Fallback
    
    case 'ensaladas':
    case 'salads':
    case 'ensalada':
      return 2; // Fallback
    
    default:
      return 1; // Default
  }
}
