import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../bloc/search/search_bloc.dart';
import '../bloc/search/search_event.dart';
import '../bloc/search/search_state.dart';
import '../models/search_result.dart';
import '../models/product.dart';
import '../l10n/app_localizations.dart';
import '../widgets/search_input_field.dart';
import 'product_detail_page.dart';
import 'product_catalog_page.dart';
import '../bloc/cart/cart_bloc.dart';

/// Página dedicada para mostrar resultados de búsqueda
class SearchResultsPage extends StatefulWidget {
  final String? initialQuery;

  const SearchResultsPage({
    Key? key,
    this.initialQuery,
  }) : super(key: key);

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  Timer? _debounceTimer;
  String _lastSearchedQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    _searchFocusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Limpiar estado anterior de búsquedas previas
        context.read<SearchBloc>().add(ClearSearch());

        // Solicitar foco automáticamente al abrir la página
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _searchFocusNode.requestFocus();

            // Si hay query inicial, disparar búsqueda
            if (widget.initialQuery != null &&
                widget.initialQuery!.isNotEmpty) {
              _lastSearchedQuery = widget.initialQuery!;
              _performSearch(widget.initialQuery!);
              // Agregar al historial
              context
                  .read<SearchBloc>()
                  .add(AddToSearchHistory(widget.initialQuery!));
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _debounceTimer?.cancel();
    // Limpiar estado del BLoC al salir de la página
    // (No limpiamos el historial, solo el resultado actual)
    super.dispose();
  }

  void _performSearch(String query) {
    final trimmedQuery = query.trim();

    // No buscar si está vacío
    if (trimmedQuery.isEmpty) {
      context.read<SearchBloc>().add(ClearSearch());
      _lastSearchedQuery = '';
      return;
    }

    // No buscar si es la misma query que la anterior
    if (trimmedQuery == _lastSearchedQuery) {
      return;
    }

    _lastSearchedQuery = trimmedQuery;

    // Cancelar búsqueda anterior si existe
    _debounceTimer?.cancel();

    // Debounce de 300ms para búsqueda automática mientras se escribe
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      context.read<SearchBloc>().add(SearchQueryChanged(trimmedQuery));
    });
  }

  void _clearSearch() {
    _searchController.clear();
    context.read<SearchBloc>().add(ClearSearch());
    _searchFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
          backgroundColor: theme.appBarTheme.backgroundColor,
          elevation: 2,
          title: Text(localizations.searchResults),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
            tooltip: localizations.back,
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            // Barra de búsqueda mejorada
            Container(
              color: theme.appBarTheme.backgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: SearchInputField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: _performSearch,
                onClearPressed: _clearSearch,
                hintText: localizations.search,
              ),
            ),
            // Contenido de resultados
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchInitial) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 64,
                            color: theme.iconTheme.color?.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            localizations.typeToSearch,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.hintColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is SearchLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: theme.primaryColor,
                      ),
                    );
                  }

                  if (state is SearchError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is SearchLoaded) {
                    if (state.results.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox,
                              size: 64,
                              color: theme.iconTheme.color?.withValues(alpha: 0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              localizations.noResultsFound,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'para "${state.query}"',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: state.results.length,
                      itemBuilder: (context, index) {
                        final result = state.results[index];
                        return _buildResultTile(context, result, theme);
                      },
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color.fromRGBO(237, 88, 33, 1),
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const ProductCatalogPage(initialIndex: 1)),
                    );
                  },
                  child: SizedBox(
                    width: 60,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          AppLocalizations.of(context)!.menu,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    final cartCount = state.cart.items
                        .fold<int>(0, (sum, item) => sum + item.quantity);
                    return InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const ProductCatalogPage(initialIndex: 2)),
                        );
                      },
                      child: SizedBox(
                        width: 60,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Icon(Icons.shopping_cart,
                                    color: Colors.white, size: 24),
                                if (cartCount > 0)
                                  Positioned(
                                    right: -6,
                                    top: -6,
                                    child: Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      constraints: const BoxConstraints(
                                          minWidth: 16, minHeight: 16),
                                      child: Text('$cartCount',
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(AppLocalizations.of(context)!.cart,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const ProductCatalogPage(initialIndex: 0)));
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(237, 231, 220, 1),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black,
                              blurRadius: 4,
                              offset: const Offset(0, 2))
                        ]),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.home, size: 28, color: Colors.black),
                        Text(AppLocalizations.of(context)!.home,
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const ProductCatalogPage(initialIndex: 4)));
                  },
                  child: SizedBox(
                      width: 60,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.delivery_dining,
                                color: Colors.white, size: 24),
                            const SizedBox(height: 2),
                            Text(AppLocalizations.of(context)!.delivery,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11))
                          ])),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                const ProductCatalogPage(initialIndex: 3)));
                  },
                  child: SizedBox(
                      width: 60,
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, color: Colors.white, size: 24),
                            const SizedBox(height: 2),
                            Text(AppLocalizations.of(context)!.profile,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 11))
                          ])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultTile(
    BuildContext context,
    SearchResult result,
    ThemeData theme,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 1,
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: result.image != null && result.image!.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  result.image!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: theme.cardColor,
                      ),
                      child: Icon(
                        result.type == 'product'
                            ? Icons.shopping_bag
                            : Icons.category,
                        color: theme.iconTheme.color?.withValues(alpha: 0.5),
                      ),
                    );
                  },
                ),
              )
            : Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: theme.cardColor,
                ),
                child: Icon(
                  result.type == 'product' ? Icons.shopping_bag : Icons.category,
                  color: theme.iconTheme.color?.withValues(alpha: 0.5),
                ),
              ),
        title: Text(
          result.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              result.type == 'product' ? 'Producto' : 'Categoría',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
            if (result.price != null && result.type == 'product')
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '\$${result.price!.toStringAsFixed(2)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                ),
              ),
          ],
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.iconTheme.color?.withValues(alpha: 0.5),
        ),
        onTap: () {
          if (result.type == 'product' && result.rawData != null) {
            // Crear un objeto Product desde el rawData
            final product = Product.fromJson(result.rawData!);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(product: product),
              ),
            );
          } else if (result.type == 'category') {
            // Navegar a categoría o mostrar productos de categoría
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.categorySelected)),
            );
          }
        },
      ),
    );
  }
}
