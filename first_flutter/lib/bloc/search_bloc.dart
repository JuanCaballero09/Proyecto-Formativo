import 'package:flutter_bloc/flutter_bloc.dart';
import 'search_event.dart';
import 'search_state.dart';
import '../service/ApiService.dart';
import '../models/search_result.dart';

/// BLoC para manejar la búsqueda de productos y categorías
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final ApiService apiService;

  SearchBloc(this.apiService) : super(const SearchInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<ClearSearch>(_onClearSearch);
    on<LoadSearchHistory>(_onLoadSearchHistory);
  }

  /// Maneja el cambio en la consulta de búsqueda
  Future<void> _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();

    // Si la búsqueda está vacía, volver al estado inicial
    if (query.isEmpty) {
      emit(const SearchInitial());
      return;
    }

    // Mostrar estado de carga
    emit(const SearchLoading());

    try {
      // Realizar búsqueda en el servicio API
      final searchData = await apiService.searchProducts(query);
      
      // Convertir los resultados a objetos SearchResult
      final List<SearchResult> results = [];

      // Agregar productos a los resultados
      if (searchData['productos'] != null) {
        for (var product in searchData['productos']) {
          results.add(SearchResult.fromProductJson(product));
        }
      }

      // Agregar categorías/grupos a los resultados
      if (searchData['grupos'] != null) {
        for (var category in searchData['grupos']) {
          results.add(SearchResult.fromCategoryJson(category));
        }
      }
      
      // Emitir estado con resultados
      emit(SearchLoaded(results, query));
    } catch (e) {
      // Emitir estado de error
      emit(SearchError('Error al buscar: ${e.toString()}'));
    }
  }

  /// Limpia la búsqueda
  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(const SearchInitial());
  }

  /// Carga el historial de búsquedas (opcional, para implementar después)
  void _onLoadSearchHistory(LoadSearchHistory event, Emitter<SearchState> emit) {
    // TODO: Implementar carga de historial desde SharedPreferences
    emit(const SearchInitial());
  }
}
