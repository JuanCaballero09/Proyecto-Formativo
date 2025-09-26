import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/base_state.dart';
import '../models/product.dart';
import '../widgets/status_widgets.dart';

/// Página de ejemplo que demuestra el uso de la nueva API de productos
/// Muestra cómo consumir los endpoints específicos por categoría
class ApiExamplePage extends StatefulWidget {
  const ApiExamplePage({super.key});

  @override
  State<ApiExamplePage> createState() => _ApiExamplePageState();
}

class _ApiExamplePageState extends State<ApiExamplePage> {
  int _selectedCategoryId = 1;
  int _selectedProductId = 1;

  @override
  void initState() {
    super.initState();
    // Cargar productos de la categoría por defecto al iniciar
    _loadProductsByCategory();
  }

  /// Carga productos usando el ID de categoría específico
  void _loadProductsByCategory() {
    context.read<ProductBloc>().add(
      LoadProductsByCategoryId(_selectedCategoryId)
    );
  }

  /// Carga un producto específico usando IDs
  void _loadSpecificProduct() {
    context.read<ProductBloc>().add(
      LoadProductByCategoryIdAndProductId(_selectedCategoryId, _selectedProductId)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Productos - Ejemplo'),
        backgroundColor: Colors.amber[800],
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección de controles
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Configuración de API',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Selector de categoría
                    Row(
                      children: [
                        const Text('Categoría ID: '),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _selectedCategoryId,
                          items: const [
                            DropdownMenuItem(value: 1, child: Text('1 - Hamburguesas')),
                            DropdownMenuItem(value: 2, child: Text('2 - Salchipapas')),
                            DropdownMenuItem(value: 3, child: Text('3 - Pizzas')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedCategoryId = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Selector de producto
                    Row(
                      children: [
                        const Text('Producto ID: '),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          value: _selectedProductId,
                          items: const [
                            DropdownMenuItem(value: 1, child: Text('1')),
                            DropdownMenuItem(value: 2, child: Text('2')),
                            DropdownMenuItem(value: 3, child: Text('3')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedProductId = value;
                              });
                            }
                          },
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Botones de acción
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.category),
                          label: const Text('Cargar Categoría'),
                          onPressed: _loadProductsByCategory,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.shopping_basket),
                          label: const Text('Cargar Producto'),
                          onPressed: _loadSpecificProduct,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Información de la petición
            Card(
              color: Colors.grey[50],
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Endpoints utilizados:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '• Categoría: /api/v1/categorias/$_selectedCategoryId/productos/',
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                    Text(
                      '• Producto: /api/v1/categorias/$_selectedCategoryId/productos/$_selectedProductId',
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Resultados
            const Text(
              'Resultados:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Lista de productos
            Expanded(
              child: BlocBuilder<ProductBloc, BaseState>(
                builder: (context, state) {
                  if (state is InitialState) {
                    return const Center(
                      child: Text(
                        'Selecciona una acción para cargar datos',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    );
                  }
                  
                  if (state is LoadingState) {
                    return LoadingWidget(
                      message: state.message ?? 'Cargando...',
                    );
                  }
                  
                  if (state is ErrorState) {
                    return ErrorDisplayWidget(
                      message: state.message,
                      onRetry: state.onRetry,
                    );
                  }
                  
                  if (state is SuccessState<List<Product>>) {
                    final products = state.data;
                    
                    if (products.isEmpty) {
                      return const EmptyStateWidget(
                        message: 'No se encontraron productos',
                        icon: Icons.shopping_basket_outlined,
                      );
                    }
                    
                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                product.image,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image),
                                  );
                                },
                              ),
                            ),
                            title: Text(
                              product.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Categoría: ${product.category}'),
                                Text('ID: ${product.id}'),
                                if (product.description.isNotEmpty)
                                  Text(
                                    product.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${product.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.green,
                                  ),
                                ),
                                const Text('COP'),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    );
                  }
                  
                  return const Center(
                    child: Text('Estado desconocido'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}