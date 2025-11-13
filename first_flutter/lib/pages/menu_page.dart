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
    context.read<CategoriasBloc>().add(LoadCategoriasEvent());
  }

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
    final theme = Theme.of(context); // 👈 usamos el tema actual
    final textColor = theme.textTheme.bodyLarge?.color; // color dinámico del texto

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            // 🔸 Título principal
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.ourMenu.toUpperCase(),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor, // 👈 texto dinámico
                ),
              ),
            ),

            // 🔸 Subtítulo
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                AppLocalizations.of(context)!.selectCategoryToSeeProducts,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textColor?.withOpacity(0.7), // 👈 texto dinámico más suave
                  height: 1.2,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔸 Grid de categorías
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
                  return _buildCategoriasGrid(state.categorias);
                } else if (state is CategoriasErrorState) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'Error al cargar categorías: ${state.error}',
                          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.redAccent),
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
                      _buildCategoriasFallbackGrid(),
                    ],
                  );
                } else {
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
          return _buildCategoryCardFromAPI(categorias[index]);
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
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => CategoryProductsPage(
              categoryName: categoria.nombre.toUpperCase(),
              categoryImage: categoria.imagenUrl ?? categoria.getDefaultImage(),
              categoryId: categoria.id,
            ),
          ),
        );
      },
      child: _categoryCardLayout(
        context: context,
        title: categoria.nombre.toUpperCase(),
        imageWidget: _buildCategoryImage(categoria),
      ),
    );
  }

  Widget _buildCategoryImage(Categoria categoria) {
    String emoji = '🍽️';
    if (categoria.nombre.isNotEmpty) {
      final runes = categoria.nombre.runes.toList();
      for (var rune in runes) {
        if (rune > 127) {
          emoji = String.fromCharCode(rune);
          break;
        }
      }
    }

    final gradientColors = _getGradientColors(categoria.nombre);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          emoji,
          style: const TextStyle(fontSize: 100),
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
    return [Colors.grey[400]!, Colors.grey[700]!];
  }

  Widget _buildCategoryCard(Map<String, String> categoria) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => CategoryProductsPage(
              categoryName: categoria['titulo']!,
              categoryImage: categoria['imagen']!,
            ),
          ),
        );
      },
      child: _categoryCardLayout(
        context: context,
        title: categoria['titulo']!,
        imageWidget: Image.asset(
          categoria['imagen']!,
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _categoryCardLayout({
    required BuildContext context,
    required String title,
    required Widget imageWidget,
  }) {
    final theme = Theme.of(context);
    return Container(
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
        color: theme.cardColor, // 👈 se adapta al modo oscuro
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageWidget,
            ),
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
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
    );
  }
}

