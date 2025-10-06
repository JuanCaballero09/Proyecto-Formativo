import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/app_localizations.dart';
import '../bloc/categorias_bloc.dart';
import '../models/categoria.dart';
import 'category_products_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  
  @override
  void initState() {
    super.initState();
    // Cargar las categorías cuando se inicializa la página
    context.read<CategoriasBloc>().add(LoadCategoriasEvent());
  }

  // Datos de fallback por si la API no responde
  List<Map<String, String>> getCategoriasFallback(BuildContext context) {
    return [
      {"titulo": AppLocalizations.of(context)!.pizzas.toUpperCase(), "imagen": "assets/Pizza Hawiana.jpg"},
      {"titulo": AppLocalizations.of(context)!.burgers.toUpperCase(), "imagen": "assets/Hamburguesa sencilla.jpg"},
      {"titulo": AppLocalizations.of(context)!.tacos.toUpperCase(), "imagen": "assets/Tacos de Pollo.jpg"},
      {"titulo": AppLocalizations.of(context)!.salads.toUpperCase(), "imagen": "assets/Ensalada Cesar.jpg"},
      {"titulo": "SALCHIPAPA", "imagen": ""},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título principal
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.ourMenu.toUpperCase(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            
            // Subtítulo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                AppLocalizations.of(context)!.selectCategoryToSeeProducts,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Grid de categorías usando BLoC
            BlocBuilder<CategoriasBloc, CategoriasState>(
              builder: (context, state) {
                if (state is CategoriasLoadingState) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(50.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (state is CategoriasLoadedState) {
                  return _buildCategoriasGrid(state.categorias);
                } else if (state is CategoriasErrorState) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Error al cargar categorías: ${state.error}',
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          context.read<CategoriasBloc>().add(LoadCategoriasEvent());
                        },
                        child: const Text('Reintentar'),
                      ),
                      const SizedBox(height: 20),
                      // Mostrar categorías de fallback en caso de error
                      _buildCategoriasFallbackGrid(),
                    ],
                  );
                } else {
                  // Estado inicial - mostrar categorías de fallback
                  return _buildCategoriasFallbackGrid();
                }
              },
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoriasGrid(List<Categoria> categorias) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categorias.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
          final categoria = categorias[index];
          return _buildCategoryCardFromAPI(categoria);
        },
      ),
    );
  }

  Widget _buildCategoriasFallbackGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: getCategoriasFallback(context).length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
          return _buildCategoryCard(getCategoriasFallback(context)[index]);
        },
      ),
    );
  }

  Widget _buildCategoryCardFromAPI(Categoria categoria) {
    return GestureDetector(
      onTap: () {
        // Debug: Ver qué categoría se está seleccionando
        print('=== DEBUG: Categoría seleccionada en MenuPage ===');
        print('ID: ${categoria.id}');
        print('Nombre original: ${categoria.name}');
        print('Nombre en mayúsculas: ${categoria.name.toUpperCase()}');
        print('Imagen: ${categoria.imagen}');
        print('=================================================');
        
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsPage(
              categoryName: categoria.name.toUpperCase(),
              categoryImage: categoria.imagen ?? "assets/imagen1.jpeg",
              categoryId: categoria.id, // SOLUCIÓN: Pasar el ID directamente
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Imagen de fondo
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildCategoryImage(categoria),
              ),
              // Overlay con gradiente
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
              ),
              // Texto del título
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        categoria.name.toUpperCase(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(237, 88, 33, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.viewProducts,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
  }

  Widget _buildCategoryImage(Categoria categoria) {
    // Mapeo de imágenes predeterminadas por nombre de categoría
    final Map<String, String> imagenesDefault = {
      // Nombres exactos de tu API
      'hamburguesas': 'assets/Hamburguesa sencilla.jpg',
      'salchipapas': 'assets/imagen1.jpeg',
      'pizzas': 'assets/Pizza Hawiana.jpg',
      
      // Variaciones por si acaso
      'hamburguesa': 'assets/Hamburguesa sencilla.jpg',
      'burger': 'assets/Hamburguesa sencilla.jpg',
      'burgers': 'assets/Hamburguesa sencilla.jpg',
      'salchipapa': 'assets/imagen1.jpeg',
      'pizza': 'assets/Pizza Hawiana.jpg',
      'tacos': 'assets/Tacos de Pollo.jpg',
      'taco': 'assets/Tacos de Pollo.jpg',
      'ensaladas': 'assets/Ensalada Cesar.jpg',
      'ensalada': 'assets/Ensalada Cesar.jpg',
      'salads': 'assets/Ensalada Cesar.jpg',
      'salad': 'assets/Ensalada Cesar.jpg',
    };
    
    String? imagePath = categoria.imagen;
    
    // Si no hay imagen de la API, usar imagen predeterminada basada en el nombre
    if (imagePath == null || imagePath.isEmpty) {
      final nombreLower = categoria.name.toLowerCase();
      imagePath = imagenesDefault[nombreLower];
      
      if (imagePath == null) {
        return _buildPlaceholderImage();
      }
    }

    // Si es una URL de internet (http/https)
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return Image.network(
        imagePath,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    } 
    // Si es un asset local
    else if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholderImage();
        },
      );
    }
    // Si es una ruta relativa, intentar como asset
    else {
      final assetPath = imagePath.startsWith('/') ? 'assets$imagePath' : 'assets/$imagePath';
      return Image.asset(
        assetPath,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          // Como último recurso, intentar como imagen de red sin protocolo
          if (imagePath != null && !imagePath.contains('://')) {
            return Image.network(
              'https://$imagePath',
              height: double.infinity,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholderImage();
              },
            );
          }
          return _buildPlaceholderImage();
        },
      );
    }
  }

  Widget _buildPlaceholderImage() {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Icon(Icons.restaurant, size: 50, color: Colors.grey),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, String> categoria) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsPage(
              categoryName: categoria['titulo']!,
              categoryImage: categoria['imagen']!,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Imagen de fondo
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  categoria['imagen']!,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
              // Overlay con gradiente
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
              ),
              // Texto del título
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        categoria['titulo']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 2,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(237, 88, 33, 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          AppLocalizations.of(context)!.viewProducts,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Efecto de presión visual
              Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductsPage(
                          categoryName: categoria['titulo']!,
                          categoryImage: categoria['imagen']!,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
