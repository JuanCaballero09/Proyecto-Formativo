import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'notificacion_Page.dart';
import 'location_Page.dart';

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
    _pageController.dispose();
    _scrollController.dispose();
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
                      icon:
                          Icon(Icons.location_on_outlined, color: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapaOSMPage(),
                          ),
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
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                ),
              ),

            // Título Promociones
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Promociones",
                style: TextStyle(
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
                "Novedades",
                style: TextStyle(
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
                      'Nuevo',
                      style: TextStyle(
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
}
