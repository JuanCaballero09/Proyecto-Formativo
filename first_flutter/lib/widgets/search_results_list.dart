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
      color: Colors.white,
      constraints: const BoxConstraints(maxHeight: 400),
      child: Column(
        children: [
          // Header con contador y botón cerrar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!),
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
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: _buildLeadingImage(result),
      title: Text(
        result.name,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (result.description != null && result.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                result.description!,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              result.type == 'product' && result.price != null
                  ? '\$${result.price!.toStringAsFixed(2)}'
                  : AppLocalizations.of(context)!.categories,
              style: TextStyle(
                color: result.type == 'product'
                    ? const Color.fromRGBO(237, 88, 33, 1)
                    : Colors.grey[600],
                fontWeight: result.type == 'product'
                    ? FontWeight.bold
                    : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey[400],
      ),
      onTap: () => onResultTap(result),
    );
  }

  /// Construye la imagen/ícono del resultado
  Widget _buildLeadingImage(SearchResult result) {
    if (result.image != null && result.image!.isNotEmpty) {
      return ClipRRect(
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
      );
    }
    return _buildDefaultIcon(result.type);
  }

  /// Construye el ícono por defecto según el tipo
  Widget _buildDefaultIcon(String type) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(237, 88, 33, 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        type == 'product' ? Icons.restaurant_menu : Icons.category,
        color: const Color.fromRGBO(237, 88, 33, 1),
        size: 30,
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
