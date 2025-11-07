// lib/pages/home_page.dart
import 'dart:async';
import 'package:first_flutter/widgets/floating_cart_button.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';
import '../models/search_result.dart';
import '../models/product.dart';
import '../models/categoria.dart';
import '../bloc/categorias/categorias_bloc.dart';
import 'LogoLoading_page.dart';
import 'notificacion_page.dart';
import 'location_page.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/base_state.dart';
import '../bloc/cart/cart_bloc.dart';
import '../models/cart_model.dart';
import 'product_detail_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final List<String> imaglist = [
    "assets/promocion1.webp",
    "assets/promocion2.jpg",
    "assets/promocion3.webp",
  ];

  late PageController _pageController;
  final ScrollController _scrollController = ScrollController();
  final ScrollController _popularScrollController = ScrollController();

  int _currentIndex = 0;
  Timer? _timer;
  bool _isPageViewReady = false;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isPageViewReady = true;
        });
        _startTimer();

        context.read<ProductBloc>().add(FetchProducts());
        context.read<CategoriasBloc>().add(LoadCategoriasEvent());
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (mounted && _isPageViewReady) {
        _currentIndex++;
        if (_currentIndex >= imaglist.length) {
          _currentIndex = 0;
        }
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _scrollController.dispose();
    _popularScrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
  Widget _buildSearchBar(BuildContext context) {
  return TextField(
    controller: _searchController,
    onChanged: (query) {
      context.read<SearchBloc>().add(SearchQueryChanged(query));
    },
    decoration: InputDecoration(
      hintText: 'Buscar productos...',
      prefixIcon: const Icon(Icons.search),
      filled: true,
      fillColor: Colors.grey[200],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/loogo.jpg',
                  width: 55,
                  height: 55,
                  fit: BoxFit.contain,
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_none, color: Colors.black),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => NotificacionPage()));
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.search, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          _isSearchVisible = !_isSearchVisible;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.location_on_outlined, color: Colors.black),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => DeliveryLocationPage()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
     body: Stack(
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isSearchVisible)
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: _buildSearchBar(context),
                    ),
                    BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        if (state is SearchLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is SearchLoaded) {
                          return state.results.isEmpty
                              ? const Center(child: Text('No se encontraron resultados'))
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: state.results.length,
                                  itemBuilder: (context, index) {
                                    final result = state.results[index];
                                    return ListTile(
                                      leading: result.image != null
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(8),
                                              child: Image.network(
                                                result.image!,
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) => Container(
                                                  width: 50,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[200],
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: const Icon(Icons.fastfood, color: Colors.grey),
                                                ),
                                              ),
                                            )
                                          : Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Icon(Icons.fastfood, color: Colors.grey),
                                            ),
                                      title: Text(
                                        result.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          if (result.type == 'product') ...[
                                            Text(
                                              result.price != null
                                                  ? '\$${NumberFormat('#,###', 'es_CO').format(result.price)}'
                                                  : 'Precio no disponible',
                                              style: const TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                          Text(
                                            'Categoría: ${result.type == 'category' ? 'Menú principal' : _getCategoryName(result)}',
                                            style: TextStyle(color: Colors.grey[600]),
                                          ),
                                          if (result.description?.isNotEmpty ?? false)
                                            Text(
                                              result.description!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                        ],
                                      ),
                                      onTap: () {
                                        if (result.type == 'product' && result.rawData != null) {
                                          final product = Product.fromJson(result.rawData!);
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ProductDetailPage(product: product),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),

              // Promociones
              _buildSectionTitle(AppLocalizations.of(context)!.todaysOffers),
              _buildPromotionsCarousel(),

              // 🧡 Productos populares
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.popularProducts,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.swipe, size: 18, color: Colors.grey),
                        const SizedBox(width: 6),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.3, end: 1.0),
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) =>
                              Opacity(opacity: value, child: child),
                          onEnd: () {
                            (context as Element).markNeedsBuild();
                          },
                          child: const Text(
                            'Desliza para ver más',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Lista horizontal de productos
              SizedBox(
                height: 270,
                child: BlocBuilder<ProductBloc, BaseState>(
                  builder: (context, state) {
                    if (state is InitialState || state is LoadingState) {
                      return Center(
                        child: LoadingAnimationWidget.threeRotatingDots(
                          color: const Color.fromRGBO(237, 88, 33, 1),
                          size: 40,
                        ),
                      );
                    } else if (state is ErrorState) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Error: ${state.message}',
                                style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<ProductBloc>().add(FetchProducts()),
                              child: const Text('Reintentar'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is SuccessState<List<Product>>) {
                      final products = state.data;
                      if (products.isEmpty) {
                        return Center(
                            child: Text(AppLocalizations.of(context)!.noProductsFound));
                      }

                      final displayList =
                          products.length > 10 ? products.sublist(0, 10) : products;

                      // ✅ Scroll táctil y con mouse
                      return ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          dragDevices: {
                            PointerDeviceKind.touch,
                            PointerDeviceKind.mouse,
                          },
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                          itemCount: displayList.length,
                          itemBuilder: (context, index) {
                            final p = displayList[index];
                            return _productCardFromModel(p);
                          },
                        ),
                      );
                    } else {
                      return Center(
                          child: Text(AppLocalizations.of(context)!.unknownState));
                    }
                  },
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),

        // 🛒 Carrito flotante
        //const FloatingCartButton(),
      ],
    ),
  );
}
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
      ),
    );
  }

  String _getCategoryName(SearchResult result) {
    if (result.rawData == null) {
      return 'Sin categoría';
    }
    final categoryId = result.rawData!['categoria_id'] ??
        result.rawData!['grupo_id'] ??
        result.rawData!['category_id'];
    if (categoryId == null) {
      return 'Sin categoría';
    }

    final categoriasState = context.read<CategoriasBloc>().state;
    if (categoriasState is CategoriasLoadedState) {
      final categoria = categoriasState.categorias.firstWhere(
        (cat) => cat.id.toString() == categoryId.toString(),
        orElse: () => Categoria(id: -1, nombre: 'Sin categoría'),
      );
      return categoria.nombre;
    }
    return 'Sin categoría';
  }

  Widget _buildPromotionsCarousel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _isPageViewReady
                ? PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemCount: imaglist.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(imaglist[index], fit: BoxFit.cover),
                      );
                    },
                  )
                : const Center(child: LogoloadingPage(size: 60)),
          ),
          const SizedBox(height: 8),
          SmoothPageIndicator(
            controller: _pageController,
            count: imaglist.length,
            effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              spacing: 8,
              activeDotColor: Colors.orange,
              dotColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _productCardFromModel(Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: product.image.isNotEmpty
                    ? Image.network(
                        product.image,
                        height: 110,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.fastfood, size: 60),
                      )
                    : Container(
                        height: 110,
                        color: Colors.grey[200],
                        child: const Center(
                            child: Icon(Icons.fastfood, size: 60)),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  product.description.isNotEmpty
                      ? (product.description.length > 40
                          ? '${product.description.substring(0, 40)}...'
                          : product.description)
                      : '',
                  style:
                      const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0, vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${NumberFormat('#,###', 'es_CO').format(product.price)}',
                      style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        backgroundColor:
                            const Color.fromRGBO(237, 88, 33, 1),
                      ),
                      onPressed: () {
                        context.read<CartBloc>().add(AddToCart(CartItem(
                              id: product.id.toString(),
                              name: product.name,
                              price: product.price,
                              quantity: 1,
                              image: product.image,
                              description: product.description,
                            )));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Añadido al carrito')),
                        );
                      },
                      child: const Icon(Icons.add_shopping_cart,
                          size: 18, color: Colors.white),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
