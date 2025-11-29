import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import '../../core/errors/exceptions.dart';
import '../../repository/api_product_repository.dart';
import '../base_state.dart';
import 'product_event.dart';
import '../../repository/product_repository.dart';
import '../../models/product.dart';

/// BLoC que maneja el estado de los productos
/// Soporta tanto repositorios locales como de API
class ProductBloc extends Bloc<ProductEvent, BaseState> {
  final ProductRepository repository;
  final Map<String, List<Product>> _cache = {}; // Caché tipado correctamente
  
  ProductBloc(this.repository) : super(const InitialState()) {
    
    // Manejo del evento para obtener todos los productos
    on<FetchProducts>((event, emit) async {
      // Si ya hay datos en caché y no es refresh forzado, retornar caché
      if (_cache.containsKey('all') && !event.forceRefresh) {
        debugPrint('📦 ProductBloc: Usando caché para todos los productos (${_cache['all']!.length} items)');
        emit(SuccessState<List<Product>>(_cache['all']!));
        return;
      }

      debugPrint('🔄 ProductBloc: Cargando productos desde API...');
      emit(const LoadingState(message: 'Loading products...'));
      try {
        final products = await repository.getProducts();
        _cache['all'] = products;
        debugPrint('✅ ProductBloc: ${products.length} productos cargados y guardados en caché');
        emit(SuccessState<List<Product>>(products));
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
          message: 'Unexpected error loading products',
          onRetry: () => add(FetchProducts()),
        ));
      }
    });

    // Manejo del evento para cargar productos por categoría (nombre)
    on<LoadProductsByCategory>((event, emit) async {
      final cacheKey = 'category_${event.categoryName}';
      
      // Si ya hay datos en caché y no es refresh forzado, retornar caché
      if (_cache.containsKey(cacheKey) && !event.forceRefresh) {
        emit(SuccessState<List<Product>>(_cache[cacheKey]!));
        return;
      }

      emit(LoadingState(
        message: 'Loading products for ${event.categoryName}...',
      ));
      try {
        final products = await repository.getProductsByCategory(event.categoryName);
        if (products.isEmpty) {
          emit(const ErrorState(
            message: 'No products found in this category',
          ));
          return;
        }
        _cache[cacheKey] = products;
        emit(SuccessState<List<Product>>(products));
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
          message: 'Unexpected error loading category products',
          onRetry: () => add(LoadProductsByCategory(event.categoryName)),
        ));
      }
    });

    // Manejo del evento para cargar productos por ID de categoría
    on<LoadProductsByCategoryId>((event, emit) async {
      final cacheKey = 'category_id_${event.categoryId}';
      
      // Si ya hay datos en caché y no es refresh forzado, retornar caché
      if (_cache.containsKey(cacheKey) && !event.forceRefresh) {
        emit(SuccessState<List<Product>>(_cache[cacheKey]!));
        return;
      }

      emit(LoadingState(
        message: 'Loading products for category ${event.categoryId}...',
      ));
      try {
        // Verificar si el repositorio soporta API directa
        if (repository is ApiProductRepository) {
          final apiRepo = repository as ApiProductRepository;
          final products = await apiRepo.getProductsByCategoryId(event.categoryId);
          if (products.isEmpty) {
            emit(const ErrorState(
              message: 'No products found in this category',
            ));
            return;
          }
          _cache[cacheKey] = products;
          emit(SuccessState<List<Product>>(products));
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
          message: 'Unexpected error loading category products',
          onRetry: () => add(LoadProductsByCategoryId(event.categoryId)),
        ));
      }
    });

    // Manejo del evento para obtener producto específico por categoría y ID
    on<LoadProductByCategoryAndId>((event, emit) async {
      emit(LoadingState(
        message: 'Loading product...',
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
            orElse: () => throw DataException(message: 'Product not found'),
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
          message: 'Unexpected error loading product',
          onRetry: () => add(LoadProductByCategoryAndId(event.categoryName, event.productId)),
        ));
      }
    });

    // Manejo del evento para obtener producto específico por IDs
    on<LoadProductByCategoryIdAndProductId>((event, emit) async {
      emit(LoadingState(
        message: 'Loading product...',
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
          message: 'Unexpected error loading product',
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
