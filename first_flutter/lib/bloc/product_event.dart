
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

/// Evento para obtener todos los productos
class FetchProducts extends ProductEvent {}

/// Evento para cargar productos por categoría usando nombre de categoría
class LoadProductsByCategory extends ProductEvent {
  final String categoryName;

  const LoadProductsByCategory(this.categoryName);

  @override
  List<Object> get props => [categoryName];
}

/// Evento para cargar productos por ID de categoría (API específica)
class LoadProductsByCategoryId extends ProductEvent {
  final int categoryId;

  const LoadProductsByCategoryId(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}

/// Evento para obtener un producto específico por categoría e ID
class LoadProductByCategoryAndId extends ProductEvent {
  final String categoryName;
  final int productId;

  const LoadProductByCategoryAndId(this.categoryName, this.productId);

  @override
  List<Object> get props => [categoryName, productId];
}

/// Evento para obtener un producto específico por ID de categoría e ID de producto
class LoadProductByCategoryIdAndProductId extends ProductEvent {
  final int categoryId;
  final int productId;

  const LoadProductByCategoryIdAndProductId(this.categoryId, this.productId);

  @override
  List<Object> get props => [categoryId, productId];
}
