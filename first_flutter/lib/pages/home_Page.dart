import 'dart:async';
import 'package:flutter/material.dart';
import 'notificacion_Page.dart';
import 'location_Page.dart';
import 'product_detail_page.dart'; // Asegúrate de tener esta página

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final List<String> imaglist = [
    "assets/imagen1.jpeg",
    "assets/imagen2.jpeg",
    "assets/imagen3.jpeg",
  ];

  late PageController _pageController;
  final ScrollController _scrollController = ScrollController();

  int _currentIndex = 9000;
  Timer? _timer;
  bool _isPageViewReady = false;
  bool _isSearchVisible = false; // Controlar si la barra de búsqueda es visible
  TextEditingController _searchController =
      TextEditingController(); // Controlador del TextField

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);

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
        try {
          _pageController.animateToPage(
            _currentIndex,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        } catch (e) {
          // Si hay un error, cancelamos el timer
          _timer?.cancel();
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    if (mounted) {
      _pageController.dispose();
      _scrollController.dispose();
      _searchController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 6.0, right: 16.0, top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // LOGO BITEVIA
                SizedBox(
                  width: 130, // Ajusta este valor según lo necesites
                  height: 100, // Altura deseada
                  child: FittedBox(
                    child: Image.asset('assets/logoredondo.png'),
                  ),
                ),
                // ÍCONOS A LA DERECHA
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
                          _isSearchVisible =
                              !_isSearchVisible; // Toggle la visibilidad
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.location_on_outlined,
                        color: Colors.black,
                      ),
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
            // Barra de búsqueda (solo visible si _isSearchVisible es true)
            if (_isSearchVisible)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
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
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),

            // Texto de promociones (arriba del carrusel)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                "Promociones",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            // Carrusel de imágenes
            Container(
              height:
                  MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top -
                  200,
              child: _isPageViewReady
                  ? PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        if (mounted) {
                          setState(() {
                            _currentIndex = index;
                          });
                        }
                      },
                      itemBuilder: (context, index) {
                        final actualIndex = index % imaglist.length;
                        return Container(
                          color: Colors.black12,
                          alignment: Alignment.center,
                          child: Image.asset(
                            imaglist[actualIndex],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        );
                      },
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
            ),

            // Texto de Novedades (debajo del carrusel)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Text(
                "Novedades",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

           // Lista de productos estáticos con menor espacio entre ellos
// Lista de productos estáticos con menor espacio entre ellos
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8.0), // Reducido el padding alrededor
  child: Row(
    mainAxisAlignment: MainAxisAlignment.start,  // Alineamos los productos al inicio
    children: [
      // Producto 1
      Container(
        width: 140,  // Tamaño fijo para la imagen del producto
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/product1.jpg', // Asegúrate de que esta imagen esté en la carpeta assets
              width: 120,  // Tamaño reducido de la imagen
              height: 120, // Tamaño reducido de la imagen
              fit: BoxFit.cover,
            ),
            SizedBox(height: 6), // Reducido el espacio entre la imagen y el texto
            Text(
              "Producto 1",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text("\$100", style: TextStyle(fontSize: 14, color: Colors.green)),
          ],
        ),
      ),

      SizedBox(width: 8),  // Reducido el espacio entre los productos

      // Producto 2
      Container(
        width: 140,  // Tamaño fijo para la imagen del producto
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/product2.jpg', // Asegúrate de que esta imagen esté en la carpeta assets
              width: 120,  // Tamaño reducido de la imagen
              height: 120, // Tamaño reducido de la imagen
              fit: BoxFit.cover,
            ),
            SizedBox(height: 6), // Reducido el espacio entre la imagen y el texto
            Text(
              "Producto 2",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text("\$150", style: TextStyle(fontSize: 14, color: Colors.green)),
          ],
        ),
      ),
    ],
  ),
),

          