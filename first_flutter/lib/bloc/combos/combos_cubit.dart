import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/product.dart';
import '../../service/api_service.dart';
import '../base_state.dart';

class CombosCubit extends Cubit<BaseState> {
  final ApiService _apiService;

  CombosCubit({ApiService? apiService})
      : _apiService = apiService ?? ApiService(),
        super(InitialState());

  /// Carga los combos desde la API
  Future<void> loadCombos({bool forceRefresh = false}) async {
    try {
      // Solo mostrar loading si no hay datos previos o se fuerza el refresh
      if (state is! SuccessState || forceRefresh) {
        emit(LoadingState());
      }

      final combos = await _apiService.getCombos();
      
      emit(SuccessState<List<Product>>(combos));
    } catch (e) {
      emit(ErrorState(
        message: e.toString(),
        code: 'COMBOS_LOAD_ERROR',
      ));
    }
  }

  /// Recarga los combos (útil para pull-to-refresh)
  Future<void> refresh() async {
    await loadCombos(forceRefresh: true);
  }
}
