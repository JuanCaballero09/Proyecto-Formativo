import 'package:equatable/equatable.dart';

/// Eventos para el SearchBloc
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Evento cuando el usuario cambia el texto de búsqueda
class SearchQueryChanged extends SearchEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

/// Evento para limpiar la búsqueda
class ClearSearch extends SearchEvent {
  const ClearSearch();
}

/// Evento para cargar el historial de búsquedas
class LoadSearchHistory extends SearchEvent {
  const LoadSearchHistory();
}

/// Evento para agregar una búsqueda al historial
class AddToSearchHistory extends SearchEvent {
  final String query;

  const AddToSearchHistory(this.query);

  @override
  List<Object?> get props => [query];
}

/// Evento para eliminar un item del historial
class RemoveFromSearchHistory extends SearchEvent {
  final String query;

  const RemoveFromSearchHistory(this.query);

  @override
  List<Object?> get props => [query];
}
