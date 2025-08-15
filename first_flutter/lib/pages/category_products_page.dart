import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../models/product.dart';
import 'product_detail_page.dart';

class CategoryProductsPage extends StatefulWidget {
  final String categoryName;
  final String categoryImage;

  const CategoryProductsPage({
    super.key,
    required this.categoryName,
    required this.categoryImage,
  });

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  @override
  void initState() {
    super.initState();
    print('CategoryProductsPage initState - Category: ${widget.categoryName}');
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<ProductBloc>().state;
      print('Current ProductBloc state in initState: ${state.runtimeType}');
      
      if (state is! ProductLoaded) {
        print('State is not ProductLoaded, triggering FetchProducts');
        context.read<ProductBloc>().add(FetchProducts());
      } else {
        print('State is ProductLoaded with ${state.products.length} products');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName.toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromRGBO(237, 88, 33, 1),
        elevation: 2,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          print('Current state: ${state.runtimeType}');
          
          if (state is ProductInitial) {
            print('State is ProductInitial - triggering FetchProducts');
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Iniciando carga de productos...'),
                ],
              ),
            );
          } else if (state is ProductLoading) {
            print('State is ProductLoading');
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando productos...'),
                ],
              ),
            );
          } else if (state is ProductLoaded) {
            // Debug: Imprimir información para depuración
            print('=== CATEGORY PRODUCTS DEBUG ===');
            print('Total products loaded: ${state.products.length}');
            print('Category name: "${widget.categoryName}"');
            print('Products:');
            
            // Imprimir TODOS los nombres de productos
            for (int i = 0; i < state.products.length; i++) {
              print('  ${i + 1}. "${state.products[i].name}" (ID: ${state.products[i].id})');
            }
            
            // Filtrar productos por categoría usando un filtro más inteligente
            final filteredProducts = state.products
                .where((product) => _matchesCategory(product, widget.categoryName))
                .toList();
                
            print('Filtered products count: ${filteredProducts.length}');
            print('Filtered products:');
            for (int i = 0; i < filteredProducts.length; i++) {
              print('  ${i + 1}. "${filteredProducts[i].name}"');
            }
            print('=== END DEBUG ===');

            // Si no hay productos filtrados, mostrar todos temporalmente para debug
            final displayProducts = filteredProducts.isEmpty ? state.products : filteredProducts;
            
            if (state.products.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No se han cargado productos desde la API',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            if (filteredProducts.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.restaurant_menu_outlined,
                      size: 80,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No hay productos en esta categoría',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Categoría: ${widget.categoryName}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                    Text(
                      'Total productos cargados: ${state.products.length}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Mostrar todos los productos sin filtrar para debug
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Productos disponibles'),
                            content: SizedBox(
                              width: double.maxFinite,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.products.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title: Text(state.products[index].name),
                                    subtitle: Text('ID: ${state.products[index].id}'),
                                  );
                                },
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cerrar'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Ver todos los productos (Debug)'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Header con imagen de la categoría
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(widget.categoryImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.categoryName.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: Offset(0, 2),
                                  blurRadius: 4,
                                  color: Colors.black54,
                                ),
                              ],
                            ),
                          ),
                          if (filteredProducts.isEmpty)
                            const Text(
                              '(Mostrando todos los productos para debug)',
                              style: TextStyle(
                                color: Colors.yellow,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Lista de productos
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.65, // Cambié de 0.75 a 0.65 para hacer las tarjetas más altas
                      ),
                      itemCount: displayProducts.length,
                      itemBuilder: (context, index) {
                        final product = displayProducts[index];
                        return Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetailPage(product: product),
                                ),
                              );
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Imagen del producto
                                Expanded(
                                  flex: 3,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.network(
                                      product.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Container(
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Información del producto
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Nombre del producto
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        
                                        // Descripción del producto
                                        Text(
                                          product.description,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey[600],
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        
                                        // Ingredientes si existen
                                        if (product.ingredients.isNotEmpty) ...[
                                          const SizedBox(height: 6),
                                          Text(
                                            'Ingredientes:',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange[700],
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Expanded(
                                            child: Text(
                                              product.ingredients.join(', '),
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey[700],
                                                fontStyle: FontStyle.italic,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ] else ...[
                                          // Si no hay ingredientes, dar más espacio a la descripción
                                          Expanded(
                                            child: Container(),
                                          ),
                                        ],
                                        
                                        const SizedBox(height: 8),
                                        
                                        // Precio del producto
                                        Text(
                                          NumberFormat.currency(
                                            locale: 'es_CO',
                                            symbol: '\$',
                                            decimalDigits: 0,
                                          ).format(product.price),
                                          style: const TextStyle(
                                            color: Color.fromRGBO(237, 88, 33, 1),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          } else if (state is ProductError) {
            print('State is ProductError: ${state.message}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar productos',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      print('Retry button pressed - triggering FetchProducts');
                      context.read<ProductBloc>().add(FetchProducts());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          } else {
            print('Unknown state: ${state.runtimeType}');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Estado desconocido'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      print('Reload button pressed - triggering FetchProducts');
                      context.read<ProductBloc>().add(FetchProducts());
                    },
                    child: const Text('Recargar'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  // Método para filtrar productos por categoría de forma más flexible
  bool _matchesCategory(Product product, String categoryName) {
    final productName = product.name.toLowerCase();
    final category = categoryName.toLowerCase();
    
    print('Checking product: "$productName" against category: "$category"');
    
    bool matches = false;
    switch (category) {
      case 'pizza':
        matches = productName.contains('pizza');
        break;
      case 'hamburguesa':
        matches = productName.contains('hamburguesa') || productName.contains('burger');
        break;
      case 'taco':
        matches = productName.contains('taco');
        break;
      case 'ensalada':
        matches = productName.contains('ensalada') || productName.contains('salad');
        break;
      case 'bebida':
        matches = productName.contains('bebida') || 
               productName.contains('jugo') || 
               productName.contains('refresco') ||
               productName.contains('agua') ||
               productName.contains('cafe') ||
               productName.contains('té');
        break;
      default:
        matches = productName.contains(category);
        break;
    }
    
    print('Product "$productName" matches category "$category": $matches');
    return matches;
  }
}
