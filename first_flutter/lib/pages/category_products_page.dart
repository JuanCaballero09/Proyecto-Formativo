import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/base_state.dart';
import '../widgets/status_widgets.dart';
import '../models/product.dart';
import 'product_detail_page.dart';

class CategoryProductsPage extends StatefulWidget {
  final String categoryName;
  final String categoryImage;
  final int? categoryId; // Nuevo: ID opcional de la categoría

  const CategoryProductsPage({
    super.key,
    required this.categoryName,
    required this.categoryImage,
    this.categoryId, // Agregar este parámetro
  });

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  @override
  void initState() {
    super.initState();
    // Debug: Ver qué categoría se está cargando
    print('=== DEBUG: CategoryProductsPage.initState ===');
    print('Categoría solicitada: ${widget.categoryName}');
    print('ID de categoría: ${widget.categoryId}');
    print('Imagen de categoría: ${widget.categoryImage}');
    print('==========================================');
    
    // Usar el ID si está disponible, sino usar el nombre
    if (widget.categoryId != null) {
      print('✓ Usando ID de categoría: ${widget.categoryId}');
      context.read<ProductBloc>().add(LoadProductsByCategoryId(widget.categoryId!));
    } else {
      print('⚠️ ID no disponible, usando nombre: ${widget.categoryName}');
      context.read<ProductBloc>().add(LoadProductsByCategory(widget.categoryName));
    }
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
      body: BlocBuilder<ProductBloc, BaseState>(
        builder: (context, state) {
          if (state is InitialState) {
            return LoadingWidget(
              message: AppLocalizations.of(context)!.loadingProducts
            );
          } 
          
          if (state is LoadingState) {
            return LoadingWidget(
              message: state.message ?? AppLocalizations.of(context)!.loadingProducts
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
              return EmptyStateWidget(
                message: AppLocalizations.of(context)!.noProductsFound,
                icon: Icons.restaurant_menu_outlined,
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
                          Colors.black.withOpacity(0.6),
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        widget.categoryName.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32,
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
                        childAspectRatio: 0.65,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return Card(
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              // Debug: Verificar qué producto se está pasando
                              print('=== DEBUG: Producto seleccionado ===');
                              print('ID: ${product.id}');
                              print('Nombre: ${product.name}');
                              print('Categoría: ${product.category}');
                              print('Precio: ${product.price}');
                              print('Index en la lista: $index');
                              print('====================================');
                              
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailPage(
                                    key: ValueKey('product_${product.id}'), // Forzar reconstrucción
                                    product: product,
                                  ),
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
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      product.image,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.broken_image_outlined,
                                          size: 50,
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                // Información del producto
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Nombre del producto
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        // Descripción del producto
                                        if (product.description.isNotEmpty)
                                          Text(
                                            product.description,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        const SizedBox(height: 4),
                                        // Ingredientes (si hay)
                                        if (product.ingredients.isNotEmpty)
                                          Text(
                                            'Ingredientes: ${product.ingredients.take(3).join(", ")}${product.ingredients.length > 3 ? "..." : ""}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontStyle: FontStyle.italic,
                                              color: Colors.black54,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        const SizedBox(height: 4),
                                        // Precio y categoría
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Precio
                                            Text(
                                              '\$${NumberFormat('#,###', 'es_CO').format(product.price)} COP',
                                              style: TextStyle(
                                                color: Colors.green[700],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            // Categoría
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(237, 88, 33, 0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                product.category,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Color.fromRGBO(237, 88, 33, 1),
                                                ),
                                              ),
                                            ),
                                          ],
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
          }
          
          // Estado desconocido
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.unknownState),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<ProductBloc>().add(LoadProductsByCategory(widget.categoryName));
                  },
                  child: Text(AppLocalizations.of(context)!.reload),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
