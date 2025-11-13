import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../l10n/app_localizations.dart';
import '../bloc/categorias/categorias_bloc.dart';
import '../models/categoria.dart';
import 'category_products_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            
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
                   height: 1.0, // reduce el alto de línea
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Grid de categorías usando BLoC
            BlocBuilder<CategoriasBloc, CategoriasState>(
              builder: (context, state) {
                if (state is CategoriasLoadingState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: LoadingAnimationWidget.threeRotatingDots(
                        color: const Color.fromRGBO(237, 88, 33, 1),
                        size: 40,
                      ),
                    ),
                  );
                } else if (state is CategoriasLoadedState) {
                  // ✅ Mostrar categorías desde la API si están disponibles
                  if (state.categorias.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.restaurant_menu_outlined,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)!.noProductsConnection,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () {
                                context.read<CategoriasBloc>().add(LoadCategoriasEvent());
                              },
                              icon: const Icon(Icons.refresh),
                              label: Text(AppLocalizations.of(context)!.retry),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return _buildCategoriasGrid(state.categorias);
                } else if (state is CategoriasErrorState) {
                  // ❌ Error - NO mostrar fallback, mostrar mensaje de error
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.wifi_off_outlined,
                            size: 80,
                            color: Colors.red[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            AppLocalizations.of(context)!.networkError,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.error,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              height: 1.4,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () {
                              context.read<CategoriasBloc>().add(LoadCategoriasEvent());
                            },
                            icon: const Icon(Icons.refresh),
                            label: Text(AppLocalizations.of(context)!.retry),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // ⏳ Estado inicial - mostrar loading o placeholder
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(50.0),
                      child: LoadingAnimationWidget.threeRotatingDots(
                        color: const Color.fromRGBO(237, 88, 33, 1),
                        size: 40,
                      ),
                    ),
                  );
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

  Widget _buildCategoryCardFromAPI(Categoria categoria) {
    return GestureDetector(
      onTap: () {
        // Debug: Ver qué categoría se está seleccionando
        print('=== DEBUG: Categoría seleccionada en MenuPage ===');
        print('ID: ${categoria.id}');
        print('Nombre original: ${categoria.nombre}');
        print('Nombre en mayúsculas: ${categoria.nombre.toUpperCase()}');
        print('Imagen: ${categoria.imagenUrl}');
        print('=================================================');
        
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => CategoryProductsPage(
              categoryName: categoria.nombre.toUpperCase(),
              categoryImage: categoria.imagenUrl ?? categoria.getDefaultImage(),
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
                        categoria.nombre.toUpperCase(),
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
    // Extraer el emoji del nombre de la categoría
    String emoji = '🍽️'; // Emoji por defecto
    
    if (categoria.nombre.isNotEmpty) {
      // Buscar el primer emoji en el nombre
      final runes = categoria.nombre.runes.toList();
      for (var rune in runes) {
        final char = String.fromCharCode(rune);
        // Verificar si es un emoji (código Unicode > 127)
        if (rune > 127) {
          emoji = char;
          break;
        }
      }
    }
    
    // Definir colores de gradiente según la categoría
    List<Color> gradientColors = _getGradientColors(categoria.nombre);
    
    print('📸 Mostrando emoji para ${categoria.nombre}: $emoji');

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(
            fontSize: 100,
            shadows: [
              Shadow(
                offset: Offset(2, 2),
                blurRadius: 4,
                color: Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(String nombre) {
    final nombreLower = nombre.toLowerCase();
    
    if (nombreLower.contains('hamburguesa') || nombreLower.contains('burger')) {
      return [Colors.orange[300]!, Colors.orange[600]!];
    } else if (nombreLower.contains('pizza')) {
      return [Colors.red[300]!, Colors.red[600]!];
    } else if (nombreLower.contains('salchipapa') || nombreLower.contains('papas')) {
      return [Colors.amber[400]!, Colors.amber[700]!];
    } else if (nombreLower.contains('bebida') || nombreLower.contains('drink')) {
      return [Colors.blue[300]!, Colors.blue[600]!];
    } else if (nombreLower.contains('postre') || nombreLower.contains('dessert')) {
      return [Colors.pink[300]!, Colors.pink[600]!];
    } else if (nombreLower.contains('taco')) {
      return [Colors.green[300]!, Colors.green[600]!];
    } else if (nombreLower.contains('ensalada') || nombreLower.contains('salad')) {
      return [Colors.lightGreen[300]!, Colors.lightGreen[600]!];
    }
    
    // Color por defecto
    return [Colors.grey[400]!, Colors.grey[700]!];
  }
}
