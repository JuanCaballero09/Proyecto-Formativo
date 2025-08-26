
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_event.dart';
import 'product_state.dart';
import '../repository/product_repository.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(ProductInitial()) {
    on<FetchProducts>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await repository.getProducts();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError('Error al cargar los productos'));
      }
    });

    on<LoadProductsByCategory>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await repository.getProductsByCategory(event.categoryName);
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError('Error al cargar los productos de la categoría'));
      }
    });
  }
}
