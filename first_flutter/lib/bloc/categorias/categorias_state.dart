part of 'categorias_bloc.dart';

@immutable
abstract class CategoriasState {}

class CategoriasInitial extends CategoriasState {}

class CategoriasLoadingState extends CategoriasState{}

class CategoriasLoadedState extends CategoriasState{
  final List<Categoria> categorias;

  CategoriasLoadedState(this.categorias);
}

class CategoriasErrorState extends CategoriasState{
  final String error;

  CategoriasErrorState(this.error);
} 
