import 'package:bloc/bloc.dart';
import 'package:first_flutter/service/ApiService.dart';
import 'package:meta/meta.dart';

//paso
part 'categorias_event.dart';
part 'categorias_state.dart';

class CategoriasBloc extends Bloc<CategoriasEvent, CategoriasState> {
  final ApiService apiService;

  CategoriasBloc(this.apiService) : super(CategoriasInitial()) {
    on<LoadCategoriasEvent>((event, emit) async {
      emit(CategoriasLoadingState());
      try {
        final categorias = await apiService.getCategorias();
        if (categorias != null) {
          emit(CategoriasLoadedState(categorias));
        } else {
          emit(categoriasErrorState('No se pudieron cargar las categorías'));
        }
      } catch (e) {
        emit(categoriasErrorState('Error: ${e.toString()}'));
      }
    });
  }
}
