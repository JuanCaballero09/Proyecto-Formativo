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
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 🔹 Imagen superior con título y flecha
          SliverToBoxAdapter(
            child: Stack(
              children: [
                Image.asset(
                  widget.categoryImage,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
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
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 🔹 Contenido dinámico (productos / loader / error)
          SliverFillRemaining(
            child: BlocBuilder<ProductBloc, BaseState>(
              builder: (context, state) {
                if (state is InitialState || state is LoadingState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 👇 Loader de 3 puntos giratorios
                        LoadingAnimationWidget.threeRotatingDots(
                          color: const Color.fromRGBO(237, 88, 33, 1),
                          size: 40,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state is LoadingState
                              ? (state.message ??
                                  AppLocalizations.of(context)!.loadingProducts)
                              : AppLocalizations.of(context)!.loadingProducts,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
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

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                                Expanded(
                                  flex: 3,
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(16),
                                    ),
                                    child: Image.network(
                                      product.image,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.broken_image_outlined,
                                          size: 50,
                                          color: Colors.grey,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '\$${NumberFormat('#,###', 'es_CO').format(product.price)} COP',
                                              style: TextStyle(
                                                color: Colors.green[700],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                              decoration: BoxDecoration(
                                                color: const Color.fromRGBO(
                                                    237, 88, 33, 0.1),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                product.category,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Color.fromRGBO(
                                                      237, 88, 33, 1),
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
                          context
                              .read<ProductBloc>()
                              .add(LoadProductsByCategory(widget.categoryName));
                        },
                        child: Text(AppLocalizations.of(context)!.reload),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
