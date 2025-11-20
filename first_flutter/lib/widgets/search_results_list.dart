import 'package:flutter/material.dart';
import '../models/search_result.dart';
import '../l10n/app_localizations.dart';

/// Widget que muestra la lista de resultados de búsqueda
class SearchResultsList extends StatelessWidget {
  final List<SearchResult> results;
  final VoidCallback onClear;
  final Function(SearchResult) onResultTap;

  const SearchResultsList({
    super.key,
    required this.results,
    required this.onClear,
    required this.onResultTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      constraints: const BoxConstraints(maxHeight: 400),
      child: Column(
        children: [
          // Header con contador y botón cerrar
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.searchResults} (${results.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onClear,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          // Lista de resultados
          Expanded(
            child: ListView.separated(
              itemCount: results.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey[200],
              ),
              itemBuilder: (context, index) {
                return _buildResultItem(context, results[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Construye cada item de resultado
  Widget _buildResultItem(BuildContext context, SearchResult result) {
    final isProduct = result.type == 'product';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isProduct
            ? Theme.of(context).cardColor
            : const Color.fromRGBO(237, 88, 33, 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isProduct
              ? Theme.of(context).dividerColor
              : const Color.fromRGBO(237, 88, 33, 0.2),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: _buildLeadingImage(result),
        title: Row(
          children: [
            // Badge de tipo
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isProduct
                    ? const Color.fromRGBO(237, 88, 33, 1)
                    : Colors.blue[600],
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isProduct ? Icons.restaurant : Icons.category,
                    size: 12,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isProduct ? AppLocalizations.of(context)!.product : AppLocalizations.of(context)!.category,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Nombre del producto/categoría
            Expanded(
              child: Text(
                result.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (result.description != null && result.description!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  result.description!,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(fontSize: 12),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            // Precio o indicador de categoría
            if (isProduct && result.price != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(237, 88, 33, 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '\$${result.price!.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color.fromRGBO(237, 88, 33, 1),
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              )
            else if (!isProduct)
              Row(
                children: [
                  Icon(
                    Icons.arrow_forward,
                    size: 14,
                    color: Colors.blue[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    AppLocalizations.of(context)!.viewProductsOfThisCategory,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isProduct
                ? const Color.fromRGBO(237, 88, 33, 0.1)
                : Colors.blue[50],
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: isProduct
                ? const Color.fromRGBO(237, 88, 33, 1)
                : Colors.blue[600],
          ),
        ),
        onTap: () => onResultTap(result),
      ),
    );
  }

  /// Construye la imagen/ícono del resultado
  Widget _buildLeadingImage(SearchResult result) {
    final isProduct = result.type == 'product';

    if (result.image != null && result.image!.isNotEmpty) {
      return Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              result.image!,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildDefaultIcon(result.type);
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
            ),
          ),
          // Badge pequeño en la esquina para indicar el tipo
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isProduct
                    ? const Color.fromRGBO(237, 88, 33, 1)
                    : Colors.blue[600],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Icon(
                isProduct ? Icons.restaurant : Icons.category,
                size: 12,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }
    return _buildDefaultIcon(result.type);
  }

  /// Construye el ícono por defecto según el tipo
  Widget _buildDefaultIcon(String type) {
    final isProduct = type == 'product';

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isProduct
              ? [
                  const Color.fromRGBO(237, 88, 33, 0.2),
                  const Color.fromRGBO(237, 88, 33, 0.1),
                ]
              : [
                  Colors.blue[200]!,
                  Colors.blue[100]!,
                ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isProduct
              ? const Color.fromRGBO(237, 88, 33, 0.3)
              : Colors.blue[300]!,
          width: 2,
        ),
      ),
      child: Icon(
        isProduct ? Icons.restaurant_menu : Icons.category,
        color:
            isProduct ? const Color.fromRGBO(237, 88, 33, 1) : Colors.blue[700],
        size: 32,
      ),
    );
  }
}

/// Widget para mostrar cuando no hay resultados
class NoSearchResults extends StatelessWidget {
  final String query;

  const NoSearchResults({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noProductsFound,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '${AppLocalizations.of(context)!.search}: "$query"',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Widget para mostrar estado de carga
class SearchLoadingWidget extends StatelessWidget {
  const SearchLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(
            color: Color.fromRGBO(237, 88, 33, 1),
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.searching,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
