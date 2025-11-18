import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'search_event.dart';
import 'search_state.dart';
import '../../service/api_service.dart';
import '../../models/search_result.dart';

/// BLoC para manejar la búsqueda de productos y categorías
/// Incluye gestión de historial y estados mejorados para accesibilidad
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiService apiService;
  final List<String> _searchHistory = [];
  static const int maxHistoryItems = 10;

  SearchBloc(this.apiService) : super(const SearchInitial()) {
    // Usar restartable para cancelar búsquedas anteriores cuando llega una nueva
    on<SearchQueryChanged>(
      _onSearchQueryChanged,
      transformer: restartable(),
    );
    on<ClearSearch>(_onClearSearch);
    on<LoadSearchHistory>(_onLoadSearchHistory);
    on<AddToSearchHistory>(_onAddToSearchHistory);
    on<RemoveFromSearchHistory>(_onRemoveFromSearchHistory);
  }

  /// Obtiene el historial actual de búsquedas
  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  /// Maneja el cambio en la consulta de búsqueda
  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    // Si la búsqueda está vacía, volver al estado inicial
    if (query.isEmpty) {
      emit(SearchInitial(searchHistory: _searchHistory));
      return;
    }

    // Mostrar estado de carga (SIEMPRE, para resetear estado anterior)
    emit(const SearchLoading());

    try {
      // Realizar búsqueda en el servicio API
      final searchData = await apiService.searchProducts(query);
      
      // Convertir los resultados a objetos SearchResult
      final List<SearchResult> results = [];

      // Agregar productos a los resultados
      final productos = searchData['productos'];
      if (productos != null && productos is List) {
        for (var product in productos) {
          try {
            results.add(SearchResult.fromProductJson(product));
          } catch (e) {
            // Ignorar productos malformados
            print('Error procesando producto: $e');
          }
        }
      }

      // Agregar categorías a los resultados (transformado desde 'grupos')
      final categorias = searchData['categorias'] ?? searchData['grupos'];
      if (categorias != null && categorias is List) {
        for (var category in categorias) {
          try {
            results.add(SearchResult.fromCategoryJson(category));
          } catch (e) {
            // Ignorar categorías malformadas
            print('Error procesando categoría: $e');
          }
        }
      }
      
      // Agregar a historial
      _addToHistory(query);
      
      // Emitir estado con resultados y historial
      emit(SearchLoaded(
        results,
        query,
        searchHistory: _searchHistory,
      ));
    } catch (e) {
      // Emitir estado de error con historial
      print('Error en búsqueda: $e');
      emit(SearchError(
        'Error al buscar: ${e.toString()}',
        searchHistory: _searchHistory,
      ));
    }
  }

  /// Limpia la búsqueda
  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(SearchInitial(searchHistory: _searchHistory));
  }

  /// Carga el historial de búsquedas
  void _onLoadSearchHistory(LoadSearchHistory event, Emitter<SearchState> emit) {
    emit(SearchHistoryLoaded(_searchHistory));
  }

  /// Agrega una búsqueda al historial
  void _onAddToSearchHistory(
    AddToSearchHistory event,
    Emitter<SearchState> emit,
  ) {
    _addToHistory(event.query);
    emit(SearchHistoryLoaded(_searchHistory));
  }

  /// Elimina una búsqueda del historial
  void _onRemoveFromSearchHistory(
    RemoveFromSearchHistory event,
    Emitter<SearchState> emit,
  ) {
    _searchHistory.removeWhere((item) => item == event.query);
    emit(SearchHistoryLoaded(_searchHistory));
  }

  /// Agrega un elemento al historial (evita duplicados y respeta límite)
  void _addToHistory(String query) {
    // Remover duplicado si existe
    _searchHistory.removeWhere((item) => item == query);
    // Agregar al inicio
    _searchHistory.insert(0, query);
    // Limitar tamaño del historial
    if (_searchHistory.length > maxHistoryItems) {
      _searchHistory.removeLast();
    }
  }
}