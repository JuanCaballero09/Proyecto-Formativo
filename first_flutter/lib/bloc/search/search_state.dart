import 'package:equatable/equatable.dart';
import '../../models/search_result.dart';

/// Estados para el SearchBloc
abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class SearchInitial extends SearchState {
  final List<String> searchHistory;

  const SearchInitial({this.searchHistory = const []});

  @override
  List<Object?> get props => [searchHistory];
}

/// Estado mientras se está buscando
class SearchLoading extends SearchState {
  const SearchLoading();
}

/// Estado cuando se han cargado los resultados
class SearchLoaded extends SearchState {
  final List<SearchResult> results;
  final String query;
  final List<String> searchHistory;

  const SearchLoaded(
    this.results,
    this.query, {
    this.searchHistory = const [],
  });

  @override
  List<Object?> get props => [results, query, searchHistory];
}

/// Estado cuando ocurre un error
class SearchError extends SearchState {
  final String message;
  final List<String> searchHistory;

  const SearchError(
    this.message, {
    this.searchHistory = const [],
  });

  @override
  List<Object?> get props => [message, searchHistory];
}

/// Estado cuando se carga el historial
class SearchHistoryLoaded extends SearchState {
  final List<String> history;

  const SearchHistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}
