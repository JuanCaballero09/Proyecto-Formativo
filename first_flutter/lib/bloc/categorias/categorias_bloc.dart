import 'package:bloc/bloc.dart';
import 'package:first_flutter/service/api_service.dart';
import 'package:first_flutter/models/categoria.dart';
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
        final categoriasData = await apiService.getCategorias();
        if (categoriasData != null) {
          // Convertir los datos JSON a objetos Categoria
          final categorias = categoriasData
              .map<Categoria>((json) => Categoria.fromJson(json))
              .toList();
          
          emit(CategoriasLoadedState(categorias));
        } else {
          emit(CategoriasErrorState('No se pudieron cargar las categorías'));
        }
      } catch (e) {
        emit(CategoriasErrorState('Error: ${e.toString()}'));
      }
    });
  }
}
