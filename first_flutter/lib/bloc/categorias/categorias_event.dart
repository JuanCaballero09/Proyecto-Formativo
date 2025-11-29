part of 'categorias_bloc.dart';

@immutable
abstract class CategoriasEvent {}

class LoadCategoriasEvent extends CategoriasEvent {
  final bool forceRefresh;

  LoadCategoriasEvent({this.forceRefresh = false});
}
