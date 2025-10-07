import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/app_localizations.dart';
import '../bloc/language_bloc.dart';
import '../bloc/language_event.dart';
import '../bloc/language_state.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/search_results_list.dart';
import '../models/search_result.dart';
import '../models/product.dart';
import 'notificacion_Page.dart';
import 'location_Page.dart';
import 'product_detail_page.dart';
import 'category_products_page.dart';

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

  int _currentIndex = 0;
  Timer? _timer;
  bool _isPageViewReady = false;
  bool _isSearchVisible = false;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Escuchar cambios en el campo de búsqueda
    _searchController.addListener(_onSearchChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _isPageViewReady = true;
        });
        _startTimer();
      }
    });
  }

  /// Maneja cambios en el campo de búsqueda con debouncing
  void _onSearchChanged() {
    // Cancelar el temporizador anterior si existe
    _debounceTimer?.cancel();
    
    // Crear nuevo temporizador para ejecutar la búsqueda después de 500ms
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      final query = _searchController.text.trim();
      if (query.isNotEmpty) {
        context.read<SearchBloc>().add(SearchQueryChanged(query));
      } else {
        context.read<SearchBloc>().add(const ClearSearch());
      }
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (mounted && _isPageViewReady) {
        _currentIndex++;
        if (_currentIndex >= imaglist.length) {
          _currentIndex = 0;
        }
        _pageController.animateToPage(
          _currentIndex,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _debounceTimer?.cancel();
    _pageController.dispose();
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: PreferredSize(
  preferredSize: Size.fromHeight(70),
  child: SafeArea(
    child: Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 12.0), // 👈 casi pegado a la izquierda
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // LOGO
          Image.asset(
            'assets/loogo.jpg',
            width: 55,  // 👈 ajusta al tamaño que quieras
            height: 55,
            fit: BoxFit.contain,
          ),
                
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.notifications_none, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NotificacionPage(),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.search, color: Colors.black),
                      onPressed: () {
                        setState(() {
                          _isSearchVisible = !_isSearchVisible;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.location_on_outlined, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapaOSMPage(),
                          ),
                        );
                      },
                    ),
                    // Botón de idioma
                    BlocBuilder<LanguageBloc, LanguageState>(
                      builder: (context, state) {
                        if (state is LanguageLoaded) {
                          return IconButton(
                            icon: Text(
                              state.locale.languageCode == 'es' ? '🇪🇸' : '🇺🇸',
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              _showLanguageDialog(context, state.locale.languageCode);
                            },
                          );
                        }
                        return IconButton(
                          icon: Text('🇪🇸', style: TextStyle(fontSize: 20)),
                          onPressed: () {
                            _showLanguageDialog(context, 'es');
                          },
                        );
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchProducts,
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Color.fromRGBO(237, 88, 33, 1),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context.read<SearchBloc>().add(const ClearSearch());
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                    ),
                  ),
                ),
              ),

            // Resultados de búsqueda
            if (_isSearchVisible)
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return const SearchLoadingWidget();
                  } else if (state is SearchLoaded) {
                    if (state.results.isEmpty) {
                      return NoSearchResults(query: state.query);
                    }
                    return SearchResultsList(
                      results: state.results,
                      onClear: () {
                        _searchController.clear();
                        context.read<SearchBloc>().add(const ClearSearch());
                        setState(() {
                          _isSearchVisible = false;
                        });
                      },
                      onResultTap: (result) {
                        _handleSearchResultTap(context, result);
                      },
                    );
                  } else if (state is SearchError) {
                    return Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

            // Título Promociones
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.todaysOffers,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),

            // Carrusel
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: _isPageViewReady
                        ? PageView.builder(
                            controller: _pageController,
                            physics: BouncingScrollPhysics(),
                            onPageChanged: (index) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                            itemCount: imaglist.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onPanDown: (_) {
                                  _timer?.cancel();
                                },
                                onPanEnd: (_) {
                                  _startTimer();
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    imaglist[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          )
                        : Center(child: CircularProgressIndicator()),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: SmoothPageIndicator(
                      controller: _pageController,
                      count: imaglist.length,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 8,
                        activeDotColor: Colors.orange,
                        dotColor: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Novedades
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: Text(
                AppLocalizations.of(context)!.popularProducts,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildProductCard(
                      'BBQ', 'assets/Hamburguesa BBQ.jpeg', '\$16.000'),
                  _buildProductCard('Doble Queso',
                      'assets/Hamburgesa Doble Queso.jpeg', '\$15.000'),
                  _buildProductCard(
                      'BBQ', 'assets/Hamburguesa BBQ.jpeg', '\$18.000'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(String title, String imagePath, String price) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 12),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.asset(
                    imagePath,
                    height: 115,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.newProduct,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 8.0, vertical: 4.0),
              child: Text(
                price,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, String currentLanguage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Text('🇪🇸', style: TextStyle(fontSize: 24)),
                title: Text('Español'),
                trailing: currentLanguage == 'es' 
                  ? Icon(Icons.check, color: Colors.green) 
                  : null,
                onTap: () {
                  context.read<LanguageBloc>().add(ChangeLanguage(languageCode: 'es'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Text('🇺🇸', style: TextStyle(fontSize: 24)),
                title: Text('English'),
                trailing: currentLanguage == 'en' 
                  ? Icon(Icons.check, color: Colors.green) 
                  : null,
                onTap: () {
                  context.read<LanguageBloc>().add(ChangeLanguage(languageCode: 'en'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /// Maneja el tap en un resultado de búsqueda
  void _handleSearchResultTap(BuildContext context, SearchResult result) {
    // Cerrar el campo de búsqueda
    setState(() {
      _isSearchVisible = false;
    });
    _searchController.clear();
    context.read<SearchBloc>().add(const ClearSearch());

    // Navegar según el tipo de resultado
    if (result.type == 'product') {
      // Verificar que tengamos los datos completos del producto
      if (result.rawData != null) {
        try {
          // Crear objeto Product desde los datos crudos
          final product = Product.fromJson(result.rawData!);
          
          // Navegar a la página de detalle del producto
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(product: product),
            ),
          );
        } catch (e) {
          print('Error al crear producto desde búsqueda: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al abrir el producto'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Datos del producto no disponibles'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } else if (result.type == 'category') {
      // Navegar a la página de productos de la categoría
      if (result.id.isNotEmpty) {
        try {
          final categoryId = int.parse(result.id);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryProductsPage(
                categoryId: categoryId,
                categoryName: result.name,
                categoryImage: result.image ?? '', // Usar imagen del resultado o vacío
              ),
            ),
          );
        } catch (e) {
          print('Error al parsear categoryId: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al abrir la categoría'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('ID de categoría no válido'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }
}
