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
          return _buildCategoryCardFromAPI(categorias[index]);
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

  Widget _categoryCardLayout({
    required BuildContext context,
    required String title,
    required Widget imageWidget,
  }) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: imageWidget,
            ),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                color: theme.cardColor,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Center(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

