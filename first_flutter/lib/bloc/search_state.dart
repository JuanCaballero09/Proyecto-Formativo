import 'package:equatable/equatable.dart';
import '../models/search_result.dart';

/// Estados para el SearchBloc
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class SearchInitial extends SearchState {
  const SearchInitial();
}

/// Estado mientras se está buscando
class SearchLoading extends SearchState {
  const SearchLoading();
}

/// Estado cuando se han cargado los resultados
class SearchLoaded extends SearchState {
  final List<SearchResult> results;
  final String query;

  const SearchLoaded(this.results, this.query);

  @override
  List<Object?> get props => [results, query];
}

/// Estado cuando ocurre un error
class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
