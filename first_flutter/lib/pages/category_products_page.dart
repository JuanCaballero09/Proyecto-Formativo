import 'dart:async';
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
import 'package:loading_animation_widget/loading_animation_widget.dart';

class CategoryProductsPage extends StatefulWidget {
  final String categoryName;
  final String categoryImage;
  final int? categoryId;

  const CategoryProductsPage({
    super.key,
    required this.categoryName,
    required this.categoryImage,
    this.categoryId,
  });

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  @override
  void initState() {
    super.initState();
    if (widget.categoryId != null) {
      context.read<ProductBloc>().add(LoadProductsByCategoryId(widget.categoryId!));
    } else {
      context.read<ProductBloc>().add(LoadProductsByCategory(widget.categoryName));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        top: false,
        child: BlocBuilder<ProductBloc, BaseState>(
          builder: (context, state) {
            return RefreshIndicator(
              color: const Color.fromRGBO(237, 88, 33, 1),
              onRefresh: () async {
                if (widget.categoryId != null) {
                  context.read<ProductBloc>().add(LoadProductsByCategoryId(widget.categoryId!, forceRefresh: true));
                } else {
                  context.read<ProductBloc>().add(LoadProductsByCategory(widget.categoryName, forceRefresh: true));
                }
                await Future.delayed(const Duration(milliseconds: 800));
              },
              child: CustomScrollView(
                slivers: [
                  // Imagen superior con título y flecha
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        // Mostrar imagen del backend si es URL, sino asset local
                        widget.categoryImage.startsWith('http')
                            ? Image.network(
                                widget.categoryImage,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/LogoText.png',
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                widget.categoryImage,
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: double.infinity,
                                    height: 180,
                                    color: Colors.orange[400],
                                    child: const Center(
                                      child: Icon(Icons.restaurant_menu, size: 60, color: Colors.white),
                                    ),
                                  );
                                },
                              ),
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.3),
                                Colors.black.withValues(alpha: 0.6),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 16,
                          left: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              '🍔 ${widget.categoryName.toUpperCase()}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(color: Colors.black54, blurRadius: 6),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Contenido dinámico (productos / loader / error)
                  if (state is InitialState || state is LoadingState)
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingAnimationWidget.threeRotatingDots(
                              color: theme.colorScheme.primary,
                              size: 40,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state is LoadingState
                                  ? (state.message ?? AppLocalizations.of(context)!.loadingProducts)
                                  : AppLocalizations.of(context)!.loadingProducts,
                              style: TextStyle(fontSize: 16, color: theme.textTheme.bodyLarge?.color),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (state is ErrorState)
                    SliverFillRemaining(
                      child: ErrorDisplayWidget(
                        message: state.message,
                        onRetry: state.onRetry,
                      ),
                    )
                  else if (state is SuccessState<List<Product>>)
                    _buildProductGrid(state.data, theme)
                  else
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Estado desconocido',
                                style: TextStyle(color: theme.textTheme.bodyLarge?.color)),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                context.read<ProductBloc>().add(LoadProductsByCategory(widget.categoryName));
                              },
                              child: Text(AppLocalizations.of(context)!.reloadLabel),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products, ThemeData theme) {
    // Filtrar solo productos disponibles
    final availableProducts = products.where((p) => p.disponible).toList();
    
    if (availableProducts.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.restaurant_menu_outlined,
                size: 80,
                color: theme.hintColor.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 24),
              Text(
                'No hay productos disponibles',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Los productos de esta categoría\nno están disponibles actualmente',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.hintColor,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () {
                  if (widget.categoryId != null) {
                    context.read<ProductBloc>().add(LoadProductsByCategoryId(widget.categoryId!, forceRefresh: true));
                  } else {
                    context.read<ProductBloc>().add(LoadProductsByCategory(widget.categoryName, forceRefresh: true));
                  }
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.65,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final product = availableProducts[index];
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Card(
                color: theme.cardColor,
                elevation: 0,
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          key: ValueKey('product_${product.id}'),
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
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.network(
                            product.image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: theme.disabledColor.withValues(alpha: 0.1),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.fastfood_outlined,
                                    size: 50,
                                    color: theme.iconTheme.color?.withValues(alpha: 0.4),
                                  ),
                                ),
                              );
                            },
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Nombre
                              Text(
                                product.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              // Descripción
                              if (product.description.isNotEmpty)
                                Expanded(
                                  child: Text(
                                    product.description,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.6),
                                      fontSize: 12,
                                      height: 1.3,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              const SizedBox(height: 8),
                              // Precio con estilo mejorado
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(237, 88, 33, 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '\$${NumberFormat('#,###', 'es_CO').format(product.price)} COP',
                                  style: const TextStyle(
                                    color: Color.fromRGBO(237, 88, 33, 1),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: availableProducts.length,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
