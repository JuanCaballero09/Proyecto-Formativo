import 'dart:async';
import 'package:first_flutter/pages/location_Page.dart';
import 'package:first_flutter/pages/notificacion_Page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import '../models/product.dart';
import '../bloc/categorias/categorias_bloc.dart';
import 'LogoLoading_page.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/base_state.dart';
import '../bloc/cart/cart_bloc.dart';
import '../models/cart_model.dart';
import 'product_detail_page.dart';
import 'search_results_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                      icon: Icon(Icons.notifications_none,
                          color: theme.iconTheme.color),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => NotificacionPage()));
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: theme.iconTheme.color),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (c) => SearchResultsPage(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.location_on_outlined,
                          color: theme.iconTheme.color),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (c) => DeliveryLocationPage()));
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
                _buildSectionTitle(
                    AppLocalizations.of(context)!.todaysOffers, theme),
                _buildPromotionsCarousel(theme),
                _buildSectionTitle(
                    AppLocalizations.of(context)!.popularProducts, theme),
                _buildPopularProducts(theme),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: theme.textTheme.bodyMedium?.color,
        ),
      ),
    );
  }

  Widget _buildPromotionsCarousel(ThemeData theme) {
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
                      setState(() => _currentIndex = index);
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
            effect: WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              spacing: 8,
              activeDotColor: theme.colorScheme.secondary,
              dotColor: theme.disabledColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularProducts(ThemeData theme) {
    return BlocBuilder<ProductBloc, BaseState>(
      builder: (context, state) {
        if (state is LoadingState || state is InitialState) {
          return Container(
            height: 270,
            alignment: Alignment.center,
            child: LoadingAnimationWidget.threeRotatingDots(
              color: const Color.fromRGBO(237, 88, 33, 1),
              size: 40,
            ),
          );
        } else if (state is SuccessState<List<Product>>) {
          final products = state.data;
          final displayProducts =
              products.length > 10 ? products.sublist(0, 10) : products;

          if (displayProducts.isEmpty) {
            return Container(
              height: 270,
              alignment: Alignment.center,
              child: Text(AppLocalizations.of(context)!.noProductsFound),
            );
          }

          return Column(
            children: [
              SizedBox(
                height: 240,
                child: MouseRegion(
                  child: Listener(
                    onPointerSignal: (event) {
                      // Capturar evento de rueda del mouse (scroll)
                      // Usar reflection para acceder a scrollDelta
                      try {
                        final scrollDelta =
                            (event as dynamic).scrollDelta as Offset?;
                        if (scrollDelta != null && scrollDelta.dy != 0) {
                          // Calcular nueva posición basada en el delta del scroll
                          final newOffset = _popularScrollController.offset +
                              scrollDelta.dy * 0.5;
                          _popularScrollController.jumpTo(
                            newOffset.clamp(
                                0.0,
                                _popularScrollController
                                    .position.maxScrollExtent),
                          );
                        }
                      } catch (_) {
                        // Ignorar si no es un evento de scroll compatible
                      }
                    },
                    child: ListView.builder(
                      controller: _popularScrollController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: displayProducts.length,
                      itemBuilder: (context, index) {
                        final product = displayProducts[index];
                        return _productCardFromModel(product, theme);
                      },
                    ),
                  ),
                ),
              ),
              // Indicador de scroll con dots
              SizedBox(
                height: 30,
                child: Center(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        (displayProducts.length / 2).ceil(),
                        (index) => GestureDetector(
                          onTap: () {
                            _popularScrollController.animateTo(
                              index * 172.0, // 160 (card width) + 12 (margin)
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  theme.colorScheme.secondary.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        } else {
          return Container(
            height: 270,
            alignment: Alignment.center,
            child: Text(AppLocalizations.of(context)!.loadingProductsError),
          );
        }
      },
    );
  }

  Widget _productCardFromModel(Product product, ThemeData theme) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ProductDetailPage(product: product)),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        child: Card(
          color: theme.cardColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: product.image.isNotEmpty
                    ? Image.network(
                        product.image,
                        height: 110,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 110,
                        color: theme.disabledColor.withOpacity(0.2),
                        child:
                            const Center(child: Icon(Icons.fastfood, size: 60)),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  product.description.isNotEmpty
                      ? (product.description.length > 40
                          ? '${product.description.substring(0, 40)}...'
                          : product.description)
                      : '',
                  style: TextStyle(fontSize: 12, color: theme.hintColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${NumberFormat('#,###', 'es_CO').format(product.price)}',
                      style: const TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
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
                          SnackBar(content: Text(AppLocalizations.of(context)!.addedToCart)),
                        );
                      },
                      child: const Icon(Icons.add_shopping_cart,
                          size: 18, color: Colors.white),
                    ),
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
