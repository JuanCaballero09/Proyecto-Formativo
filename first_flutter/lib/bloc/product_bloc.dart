
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/errors/exceptions.dart';
import 'base_state.dart';
import 'product_event.dart';
import '../repository/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, BaseState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(const InitialState()) {
    on<FetchProducts>((event, emit) async {
      emit(const LoadingState(message: 'Cargando productos...'));
      try {
        final products = await repository.getProducts();
        emit(SuccessState(products));
      } on NetworkException catch (e) {
        emit(ErrorState(
          message: e.message,
          code: e.code,
          onRetry: () => add(FetchProducts()),
        ));
      } on DataException catch (e) {
        emit(ErrorState(
          message: e.message,
          code: e.code,
          onRetry: () => add(FetchProducts()),
        ));
      } catch (e) {
        emit(ErrorState(
          message: 'Error inesperado al cargar los productos',
          onRetry: () => add(FetchProducts()),
        ));
      }
    });

    on<LoadProductsByCategory>((event, emit) async {
      emit(LoadingState(
        message: 'Cargando productos de ${event.categoryName}...',
      ));
      try {
        final products = await repository.getProductsByCategory(event.categoryName);
        if (products.isEmpty) {
          emit(const ErrorState(
            message: 'No se encontraron productos en esta categoría',
          ));
          return;
        }
        emit(SuccessState(products));
      } on NetworkException catch (e) {
        emit(ErrorState(
          message: e.message,
          code: e.code,
          onRetry: () => add(LoadProductsByCategory(event.categoryName)),
        ));
      } on DataException catch (e) {
        emit(ErrorState(
          message: e.message,
          code: e.code,
          onRetry: () => add(LoadProductsByCategory(event.categoryName)),
        ));
      } catch (e) {
        emit(ErrorState(
          message: 'Error inesperado al cargar los productos de la categoría',
          onRetry: () => add(LoadProductsByCategory(event.categoryName)),
        ));
      }
    });
  }
}
