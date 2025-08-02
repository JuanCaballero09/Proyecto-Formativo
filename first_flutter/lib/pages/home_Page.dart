import 'dart:async';
import 'package:flutter/material.dart';
import 'notificacion_Page.dart';
import 'location_Page.dart';
import 'product_detail_page.dart'; // Asegúrate de tener esta página
import '../models/product.dart'; // Asegúrate de tener este modelo

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final List<String> imaglist = [
    "assets/imagen1.jpeg",
    "assets/imagen2.jpeg",
    "assets/imagen3.jpeg",
  ];

  late PageController _pageController;
  final ScrollController _scrollController = ScrollController();

  int _currentIndex = 1000;
  Timer? _timer;
  bool _isPageViewReady = false;

  bool mostrarNovedades = false;
  bool mostrarCategorias = false;

  final List<Map<String, String>> categorias = [
    {"titulo": "PIZZA", "imagen": "assets/Pizza Hawiana.jpg"},
    {"titulo": "TACOS", "imagen": "assets/Tacos de Pollo.jpg"},
    {"titulo": "HAMBURGUESAS", "imagen": "assets/Hamburguesa sencilla.jpg"},
    {"titulo": "ENSALADA", "imagen": "assets/Ensalada CeSar.jpg"},
    {"titulo": "BEBIDAS", "imagen": "assets/Bebida.jpg"},
  ];

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
    }
    super.dispose();
  }

  void _mostrarSeccion(String seccion) {
    setState(() {
      mostrarNovedades = seccion == 'novedades';
      mostrarCategorias = seccion == 'categorias';
    });

    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
        title: Center(child: Image.asset("assets/imagen5.png", width: 150)),
        leading: SizedBox(width: 48),
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            icon: Icon(Icons.notifications, size: 20, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificacionPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.location_on, size: 20, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapaOSMPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Botones
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildQuickLink('Promociones', () => _mostrarSeccion('')),
                  _buildQuickLink('Novedades', () => _mostrarSeccion('novedades')),
                  _buildQuickLink('Categorías', () => _mostrarSeccion('categorias')),
                ],
              ),
            ),

            // Carrusel
            if (!mostrarNovedades && !mostrarCategorias) ...[
              Container(
                height: MediaQuery.of(context).size.height -
                    kToolbarHeight -
                    MediaQuery.of(context).padding.top -
                    100,
                child: _isPageViewReady ? PageView.builder(
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
                ) : Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],

            // Novedades
            if (mostrarNovedades) ...[
              _buildNovedadesContenido(),
            ],

            // Categorías
            if (mostrarCategorias) ...[
              _buildSectionTitle('CATEGORÍAS'),
              _buildHorizontalCards(categorias),
            ],
          ],
        ),
      ),
    );
  }

 Widget _buildQuickLink(String label, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap,
    child: Chip(
      label: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromRGBO(237, 88, 33, 1), // Texto naranja
        ),
      ),
      backgroundColor: Colors.white, // Fondo blanco
      shape: StadiumBorder(
        side: BorderSide(color: Color.fromRGBO(237, 88, 33, 1)), // Borde naranja
      ),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    ),
  );
}

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildHorizontalCards(List<Map<String, String>> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3 / 2,
        ),
        itemBuilder: (context, index) {

          return GestureDetector(
            onTap: () {
              debugPrint('Tocaste: ${items[index]['titulo']}');
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.asset(
                        items[index]['imagen']!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Center(
                      child: Text(
                        items[index]['titulo']!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _buildNovedadesContenido() {
    final novedades = [
      Product(
        id: 'np1',
        name: 'Hamburguesa Doble',
        description: 'Deliciosa hamburguesa con doble carne y queso',
        price: 18000,
        image: 'assets/Hamburgesa Doble Queso.jpeg',
      ),
      Product(
        id: 'np2',
        name: 'Pizza Pepperoni',
        description: 'Pizza artesanal con pepperoni y queso mozzarella',
        price: 22000,
        image: 'assets/Pizza pepperoni.jpg',
      ),
      Product(
        id: 'np3',
        name: 'Taco De pollo',
        description: 'taco de pollo con guacamole y pico de gallo',
        price: 15000,
        image: 'assets/Tacos de Pollo.jpg',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('NUEVO PRODUCTO'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: novedades.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (context, index) {
              final product = novedades[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: product),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                          child: Image.asset(
                            product.image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.description,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '\$ ${product.price} COP',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
     _buildSectionTitle('NUEVO SERVICIO'),
Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
    childAspectRatio: 3 / 2,
    children: [
      _buildNovedadCardConTexto('assets/domicilio moto.jpg', 'Domicilio'),
    ],
  ),
),
      ],
    );
  }

Widget _buildNovedadCardConTexto(String imagePath, String titulo) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 226, 83, 31),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      ),
      SizedBox(height: 6),
      Center(
        child: Text(
          titulo,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    ],
  );
}
}