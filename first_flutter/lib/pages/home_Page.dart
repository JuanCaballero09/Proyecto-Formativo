// lib/pages/home_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:intl/intl.dart';

import '../l10n/app_localizations.dart';
import 'LogoLoading_page.dart';
import 'notificacion_Page.dart';
import 'location_Page.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/base_state.dart';
import '../models/product.dart';
import '../bloc/cart_bloc.dart';
import '../models/cart_model.dart';
import 'product_detail_page.dart';

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
  final ScrollController _scrollController = ScrollController(); // para el SingleChildScrollView
  final ScrollController _popularScrollController = ScrollController(); // para la lista horizontal de populares

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

        // PEDIR productos al ProductBloc (viene del backend)
        // Asegúrate de que ProductBloc esté provisto por un ancestor (ej. MultiBlocProvider)
        context.read<ProductBloc>().add(FetchProducts());
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

  // Scroll con flechas: avanza o retrocede cierta cantidad
  void _scrollPopular(int direction) {
    // direction: -1 izquierda, +1 derecha
    final double step = 172; // ancho tarjeta + margin (ajusta si tu card cambia)
    final double target = _popularScrollController.offset + (step * direction);
    _popularScrollController.animateTo(
      target.clamp(
        0.0,
        _popularScrollController.position.maxScrollExtent,
      ),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
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
                        Navigator.push(context, MaterialPageRoute(builder: (c) => MapaOSMPage()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_isSearchVisible)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: _buildSearchBar(context),
              ),

            // Promociones
            _buildSectionTitle(AppLocalizations.of(context)!.todaysOffers),
            _buildPromotionsCarousel(),

            // Productos populares (viene del backend via ProductBloc)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.popularProducts,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),

            // Area con flechas + lista horizontal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 260,
                child: Stack(
                  children: [
                    // Lista horizontal de productos (consumida desde ProductBloc)
                    Positioned.fill(
                      child: BlocBuilder<ProductBloc, BaseState>(
                        builder: (context, state) {
                          if (state is InitialState || state is LoadingState) {
                            return const Center(child: LogoloadingPage(size: 60));
                          } else if (state is ErrorState) {
                            return Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Error: ${state.message}', style: const TextStyle(color: Colors.red)),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () => context.read<ProductBloc>().add(FetchProducts()),
                                    child: const Text('Reintentar'),
                                  ),
                                ],
                              ),
                            );
                          } else if (state is SuccessState<List<Product>>) {
                            final products = state.data;
                            if (products.isEmpty) {
                              return Center(child: Text(AppLocalizations.of(context)!.noProductsFound));
                            }

                            // Tomar hasta 10 productos
                            final displayList = products.length > 10 ? products.sublist(0, 10) : products;

                            return ListView.builder(
                              controller: _popularScrollController,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 48.0, vertical: 8.0), // deja espacio para flechas
                              itemCount: displayList.length,
                              itemBuilder: (context, index) {
                                final p = displayList[index];
                                return _productCardFromModel(p);
                              },
                            );
                          } else {
                            return Center(child: Text(AppLocalizations.of(context)!.unknownState));
                          }
                        },
                      ),
                    ),
                    // Flecha izquierda
                    Positioned(
                      left: 8,
                      top: 0,
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: FloatingActionButton(
                          heroTag: 'leftPopular',
                          mini: true,
                          backgroundColor: Colors.white,
                          onPressed: () => _scrollPopular(-1),
                          child: const Icon(Icons.arrow_left, color: Colors.black),
                        ),
                      ),
                    ),
                    // Flecha derecha
                    Positioned(
                      right: 8,
                      top: 0,
                      bottom: 0,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: FloatingActionButton(
                          heroTag: 'rightPopular',
                          mini: true,
                          backgroundColor: Colors.white,
                          onPressed: () => _scrollPopular(1),
                          child: const Icon(Icons.arrow_right, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), spreadRadius: 2, blurRadius: 5, offset: const Offset(0, 3))],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchProducts,
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
        onChanged: (q) {
          // opcional: disparar búsqueda si implementas endpoint search en ProductBloc
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
    );
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
                : const Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 8),
          SmoothPageIndicator(
            controller: _pageController,
            count: imaglist.length,
            effect: const WormEffect(dotHeight: 8, dotWidth: 8, spacing: 8, activeDotColor: Colors.orange, dotColor: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _productCardFromModel(Product product) {
    return GestureDetector(
      onTap: () {
        // abrir detalle
        Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: product)));
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Imagen (si viene vacía, muestra placeholder automático)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: product.image.isNotEmpty
                    ? Image.network(
                        product.image,
                        height: 110,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, size: 60),
                      )
                    : Container(
                        height: 110,
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.fastfood, size: 60)),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(product.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  // descripción corta: toma primeros 40 chars
                  product.description.isNotEmpty ? (product.description.length > 40 ? '${product.description.substring(0, 40)}...' : product.description) : '',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${NumberFormat('#,###', 'es_CO').format(product.price)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
                      ),
                      onPressed: () {
                        // agregar al carrito usando CartBloc
                        context.read<CartBloc>().add(AddToCart(CartItem(
                              id: product.id.toString(),
                              name: product.name,
                              price: product.price,
                              quantity: 1,
                              image: product.image,
                              description: product.description,
                            )));

                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Añadido al carrito')));
                      },
                      child: const Icon(Icons.add_shopping_cart, size: 18, color: Colors.white),
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

