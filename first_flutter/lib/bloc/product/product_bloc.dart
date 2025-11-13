
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/errors/exceptions.dart';
import '../../repository/api_product_repository.dart';
import '../base_state.dart';
import 'product_event.dart';
import '../../repository/product_repository.dart';

/// BLoC que maneja el estado de los productos
/// Soporta tanto repositorios locales como de API
class ProductBloc extends Bloc<ProductEvent, BaseState> {
  final ProductRepository repository;

  ProductBloc(this.repository) : super(const InitialState()) {
    
    // Manejo del evento para obtener todos los productos
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

    // Manejo del evento para cargar productos por categoría (nombre)
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

    // Manejo del evento para cargar productos por ID de categoría
    on<LoadProductsByCategoryId>((event, emit) async {
      emit(LoadingState(
        message: 'Cargando productos de categoría ${event.categoryId}...',
      ));
      try {
        // Verificar si el repositorio soporta API directa
        if (repository is ApiProductRepository) {
          final apiRepo = repository as ApiProductRepository;
          final products = await apiRepo.getProductsByCategoryId(event.categoryId);
          if (products.isEmpty) {
            emit(const ErrorState(
              message: 'No se encontraron productos en esta categoría',
            ));
            return;
          }
          emit(SuccessState(products));
        } else {
          // Fallback: mapear ID a nombre de categoría para repositorios que no soportan ID directo
          final categoryName = _getCategoryNameFromId(event.categoryId);
          add(LoadProductsByCategory(categoryName));
        }
      } on NetworkException catch (e) {
        emit(ErrorState(
          message: e.message,
          code: e.code,
          onRetry: () => add(LoadProductsByCategoryId(event.categoryId)),
        ));
      } on DataException catch (e) {
        emit(ErrorState(
          message: e.message,
          code: e.code,
          onRetry: () => add(LoadProductsByCategoryId(event.categoryId)),
        ));
      } catch (e) {
        emit(ErrorState(
          message: 'Error inesperado al cargar los productos de la categoría',
          onRetry: () => add(LoadProductsByCategoryId(event.categoryId)),
        ));
      }
    });

    // Manejo del evento para obtener producto específico por categoría y ID
    on<LoadProductByCategoryAndId>((event, emit) async {
      emit(LoadingState(
        message: 'Cargando producto...',
      ));
      try {
        // Verificar si el repositorio soporta obtener producto específico
        if (repository is ApiProductRepository) {
          final apiRepo = repository as ApiProductRepository;
          final product = await apiRepo.getProductByCategoryAndId(event.categoryName, event.productId);
          emit(SuccessState([product])); // Retornar como lista para consistencia
        } else {
          // Fallback: obtener todos los productos de la categoría y filtrar
          final products = await repository.getProductsByCategory(event.categoryName);
          final product = products.firstWhere(
            (p) => p.id == event.productId,
            orElse: () => throw DataException(message: 'Producto no encontrado'),
          );
          emit(SuccessState([product]));
        }
      } on NetworkException catch (e) {
        emit(ErrorState(
          message: e.message,
          code: e.code,
          onRetry: () => add(LoadProductByCategoryAndId(event.categoryName, event.productId)),
        ));
      } on DataException catch (e) {
        emit(ErrorState(
          message: e.message,
          code: e.code,
          onRetry: () => add(LoadProductByCategoryAndId(event.categoryName, event.productId)),
        ));
      } catch (e) {
        emit(ErrorState(
          message: 'Error inesperado al cargar el producto',
          onRetry: () => add(LoadProductByCategoryAndId(event.categoryName, event.productId)),
        ));
      }
    });

    // Manejo del evento para obtener producto específico por IDs
    on<LoadProductByCategoryIdAndProductId>((event, emit) async {
      emit(LoadingState(
        message: 'Cargando producto...',
      ));
      try {
        // Verificar si el repositorio soporta API directa
        if (repository is ApiProductRepository) {
          final apiRepo = repository as ApiProductRepository;
          final product = await apiRepo.getProductByCategoryIdAndProductId(event.categoryId, event.productId);
          emit(SuccessState([product])); // Retornar como lista para consistencia
        } else {
          // Fallback: mapear ID a nombre y usar método por categoría
          final categoryName = _getCategoryNameFromId(event.categoryId);
          add(LoadProductByCategoryAndId(categoryName, event.productId));
        }
      } on NetworkException catch (e) {
        emit(ErrorState(
          message: e.message,
          code: e.code,
          onRetry: () => add(LoadProductByCategoryIdAndProductId(event.categoryId, event.productId)),
        ));
      } on DataException catch (e) {
        emit(ErrorState(
          message: e.message,
          code: e.code,
          onRetry: () => add(LoadProductByCategoryIdAndProductId(event.categoryId, event.productId)),
        ));
      } catch (e) {
        emit(ErrorState(
          message: 'Error inesperado al cargar el producto',
          onRetry: () => add(LoadProductByCategoryIdAndProductId(event.categoryId, event.productId)),
        ));
      }
    });
  }

  /// Mapea IDs de categoría a nombres
  String _getCategoryNameFromId(int categoryId) {
    switch (categoryId) {
      case 1:
        return 'hamburguesas';
      case 2:
        return 'salchipapas';
      case 3:
        return 'pizzas';
      default:
        return 'General';
    }
  }
}
