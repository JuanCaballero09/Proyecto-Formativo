import 'dart:async';
import 'package:first_flutter/pages/location_Page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../l10n/app_localizations.dart';
import '../models/product.dart';
import '../models/banner.dart' as banner_model;
import '../bloc/categorias/categorias_bloc.dart';
import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/base_state.dart';
import '../bloc/cart/cart_bloc.dart';
import '../bloc/banner/banner_bloc.dart';
import '../bloc/combos/combos_cubit.dart';
import '../models/cart_model.dart';
import 'product_detail_page.dart';
import 'search_results_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../widgets/banner_skeleton.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
  with SingleTickerProviderStateMixin {
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
    // El timer ahora se inicia dinámicamente cuando hay banners cargados
  }

  void _startBannerTimer(int bannersCount) {
    _timer?.cancel();
    if (bannersCount <= 1) return; // No iniciar timer si hay 1 o menos banners
    
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (mounted && _isPageViewReady) {
        _currentIndex++;
        if (_currentIndex >= bannersCount) {
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
      body: RefreshIndicator(
        color: const Color.fromRGBO(237, 88, 33, 1),
        onRefresh: () async {
          // Recargar productos, banners, categorías y combos en paralelo
          await Future.wait([
            Future(() => context.read<ProductBloc>().add(FetchProducts(forceRefresh: true))),
            Future(() => context.read<BannerCubit>().loadBanners(forceRefresh: true)),
            Future(() => context.read<CategoriasBloc>().add(LoadCategoriasEvent())),
            Future(() => context.read<CombosCubit>().loadCombos(forceRefresh: true)),
          ]);
          
          // Esperar un poco más para asegurar que los estados se actualicen
          await Future.delayed(const Duration(milliseconds: 800));
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(
                      AppLocalizations.of(context)!.todaysOffers, theme),
                  _buildPromotionsCarousel(theme),
                  _buildSectionTitle(
                      AppLocalizations.of(context)!.popularProducts, theme),
                  _buildPopularProducts(theme),
                  _buildCombosSection(theme),
                ],
              ),
            ),
          ],
        ),
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
    return BlocBuilder<BannerCubit, BaseState>(
      builder: (context, state) {
        if (state is LoadingState || state is InitialState) {
          // Mostrar skeleton loading
          return const BannerCarouselSkeleton();
        } else if (state is SuccessState<List<banner_model.Banner>>) {
          final banners = state.data;

          if (banners.isEmpty) {
            // No hay banners, mostrar mensaje o vista vacía
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      'No hay promociones disponibles',
                      style: TextStyle(color: theme.hintColor),
                    ),
                  ),
                ),
              ),
            );
          }

          // Iniciar timer automático cuando hay banners
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _startBannerTimer(banners.length);
            }
          });

          return LayoutBuilder(
            builder: (context, constraints) {
              // Ajustar aspect ratio según tamaño de pantalla
              final screenWidth = MediaQuery.of(context).size.width;
              final aspectRatio = screenWidth < 600 ? 16 / 9 : 
                                 screenWidth < 900 ? 2 / 1 : 2.5 / 1;
              
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    AspectRatio(
                      aspectRatio: aspectRatio,
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemCount: banners.length,
                    itemBuilder: (context, index) {
                      final banner = banners[index];
                      final screenWidth = MediaQuery.of(context).size.width;
                      final imageUrl = banner.getImageUrl(screenWidth);

                      return ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: banner.isLocal
                            ? (imageUrl.endsWith('.svg')
                                ? SvgPicture.asset(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    placeholderBuilder: (context) => BannerSkeleton(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  )
                                : Image.asset(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: theme.cardColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.image_not_supported,
                                            size: 50,
                                            color: theme.hintColor,
                                          ),
                                        ),
                                      );
                                    },
                                  ))
                            : Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return BannerSkeleton(
                                    borderRadius: BorderRadius.circular(12),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      color: theme.cardColor,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 50,
                                        color: theme.hintColor,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: banners.length,
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
            },
          );
        } else if (state is ErrorState) {
          // Error al cargar banners
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off_outlined,
                      size: 50,
                      color: Colors.red[300],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Error al cargar promociones',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[400],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.hintColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<BannerCubit>().loadBanners();
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // Estado desconocido, mostrar skeleton
        return const BannerCarouselSkeleton();
      },
    );
  }

  Widget _buildPopularProducts(ThemeData theme) {
    return BlocConsumer<ProductBloc, BaseState>(
      listener: (context, state) {
        // Listener para reactividad
      },
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
          final allProducts = state.data;
          
          // Filtrar solo productos disponibles
          final products = allProducts.where((p) => p.disponible).toList();
          
          // Algoritmo para seleccionar productos "populares"
          // Prioridad 1: Si hay datos de ventas (salesCount), ordenar por eso
          // Prioridad 2: Variedad de categorías + precio medio
          List<Product> displayProducts = [];
          
          if (products.isNotEmpty) {
            // Verificar si hay datos de ventas
            final hasSalesData = products.any((p) => p.salesCount > 0);
            
            if (hasSalesData) {
              // 🔥 Ordenar por productos más vendidos
              displayProducts = List.from(products);
              displayProducts.sort((a, b) => b.salesCount.compareTo(a.salesCount));
              
              // Tomar los 10 más vendidos
              if (displayProducts.length > 10) {
                displayProducts = displayProducts.sublist(0, 10);
              }
              
              debugPrint('📊 Mostrando productos ordenados por ventas');
            } else {
              // 📈 Usar algoritmo de variedad (sin datos de ventas)
              // Agrupar por categoría
              Map<String, List<Product>> productsByCategory = {};
              for (var product in products) {
                if (!productsByCategory.containsKey(product.category)) {
                  productsByCategory[product.category] = [];
                }
                productsByCategory[product.category]!.add(product);
              }
              
              // Tomar 1-2 productos de cada categoría para variedad
              for (var categoryProducts in productsByCategory.values) {
                // Ordenar por precio (productos de precio medio son más atractivos)
                categoryProducts.sort((a, b) => a.price.compareTo(b.price));
                
                // Tomar del medio (evitar los muy baratos o muy caros)
                final middleIndex = categoryProducts.length ~/ 2;
                if (categoryProducts.isNotEmpty) {
                  displayProducts.add(categoryProducts[middleIndex]);
                }
                
                // Si la categoría tiene más de 3 productos, agregar uno más
                if (categoryProducts.length > 3 && displayProducts.length < 10) {
                  final secondIndex = (middleIndex + 1) < categoryProducts.length 
                      ? middleIndex + 1 
                      : middleIndex - 1;
                  if (secondIndex >= 0 && secondIndex < categoryProducts.length) {
                    displayProducts.add(categoryProducts[secondIndex]);
                  }
                }
              }
              
              // Si aún no tenemos 10, completar con productos aleatorios
              if (displayProducts.length < 10 && products.length > displayProducts.length) {
                final remainingProducts = products.where((p) => !displayProducts.contains(p)).toList();
                remainingProducts.shuffle(); // Aleatorizar
                final needed = (10 - displayProducts.length).clamp(0, remainingProducts.length);
                displayProducts.addAll(remainingProducts.take(needed));
              }
              
              // Mezclar un poco para que no se vea tan predecible
              displayProducts.shuffle();
              
              // Limitar a 10
              if (displayProducts.length > 10) {
                displayProducts = displayProducts.sublist(0, 10);
              }
              
              debugPrint('📊 Mostrando productos con algoritmo de variedad');
            }
          }

if (displayProducts.isEmpty) {
  return Container(
    height: 270,
    alignment: Alignment.center,
    padding: const EdgeInsets.all(32.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.wifi_off_outlined,       // 🔥 Ícono de internet caído
          size: 60,
          color: Colors.red[300],
        ),
        const SizedBox(height: 12),

        // 🔥 Texto principal
        Text(
          "No hay conexión a internet",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // 🔥 Texto secundario
        Text(
          "Por favor verifica tu conexión e intenta nuevamente.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 24),

        // 🔄 Botón Reintentar
        ElevatedButton.icon(
          onPressed: () {
            context.read<ProductBloc>().add(FetchProducts());
          },
          icon: const Icon(Icons.refresh),
          label: Text(AppLocalizations.of(context)!.retry),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[400],
          ),
        ),
      ],
    ),
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
void showSimpleAddedDialog(BuildContext context) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;
  
  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 20,
      right: 20,
      child: Material(
        color: Colors.transparent,
        child: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 400),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: Opacity(
                opacity: value.clamp(0.0, 1.0),
                child: child,
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4CAF50),
                  Color(0xFF45A049),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF4CAF50).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.addedToCart,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '¡Tu producto está listo!',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(milliseconds: 2500), () {
    overlayEntry.remove();
  });
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
        width: 170,
        margin: const EdgeInsets.only(right: 12),
        child: Card(
          color: theme.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Imagen del producto con skeleton loading
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: product.image.isNotEmpty
                    ? Stack(
                        children: [
                          // Skeleton de fondo
                          const BannerSkeleton(
                            height: 120,
                            width: double.infinity,
                            borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          ),
                          // Imagen real
                          Image.network(
                            product.image,
                            height: 120,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const BannerSkeleton(
                                height: 120,
                                width: double.infinity,
                                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: 120,
                                color: theme.disabledColor.withValues(alpha: 0.2),
                                child: const Center(
                                  child: Icon(Icons.fastfood, size: 60),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : Container(
                        height: 120,
                        color: theme.disabledColor.withValues(alpha: 0.2),
                        child: const Center(child: Icon(Icons.fastfood, size: 60)),
                      ),
              ),
              
              // Nombre del producto
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              // Precio prominente
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Text(
                  '\$${NumberFormat('#,###', 'es_CO').format(product.price)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(237, 88, 33, 1),
                  ),
                ),
              ),
              
              // Botón de compra que ocupa todo el ancho
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(237, 88, 33, 1),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromRGBO(237, 88, 33, 0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        context.read<CartBloc>().add(AddToCart(
                          CartItem(
                            id: product.id.toString(),
                            name: product.name,
                            price: product.price,
                            quantity: 1,
                            image: product.image,
                            description: product.description,
                          ),
                        ));
                        showSimpleAddedDialog(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              AppLocalizations.of(context)!.addToCart,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 0.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCombosSection(ThemeData theme) {
    return BlocBuilder<CombosCubit, BaseState>(
      builder: (context, state) {
        // Mientras carga, mostrar loading animation
        if (state is LoadingState || state is InitialState) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  'Ofertas Especiales',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
              ),
              Container(
                height: 200,
                alignment: Alignment.center,
                child: LoadingAnimationWidget.threeRotatingDots(
                  color: const Color.fromRGBO(237, 88, 33, 1),
                  size: 40,
                ),
              ),
            ],
          );
        }
        
        // Si hay error, no mostrar nada
        if (state is ErrorState) {
          return const SizedBox.shrink();
        }
        
        if (state is SuccessState<List<Product>>) {
          final combos = state.data;
          
          // Si no hay combos, no mostrar la sección
          if (combos.isEmpty) {
            return const SizedBox.shrink();
          }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Ofertas Especiales',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyMedium?.color,
                ),
              ),
            ),
            SizedBox(
              height: 240,
              child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: combos.length,
              itemBuilder: (context, index) {
                final combo = combos[index];
                return _productCardFromModel(combo, theme);
              },
            ),
          ),
            const SizedBox(height: 20),
            ],
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }
  
}
