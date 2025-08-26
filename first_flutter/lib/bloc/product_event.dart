
import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductEvent {}

class LoadProductsByCategory extends ProductEvent {
  final String categoryName;

  const LoadProductsByCategory(this.categoryName);

  @override
  List<Object> get props => [categoryName];
}
