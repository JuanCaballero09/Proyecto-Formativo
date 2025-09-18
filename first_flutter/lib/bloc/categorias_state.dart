part of 'categorias_bloc.dart';

@immutable
abstract class CategoriasState {}

class CategoriasInitial extends CategoriasState {}

class CategoriasLoadingState extends CategoriasState{}

class CategoriasLoadedState extends CategoriasState{
  final List<dynamic> categorias;

  CategoriasLoadedState(this.categorias);
}

class categoriasErrorState extends CategoriasState{
  final String error;

  categoriasErrorState(this.error);
  
  

} 
