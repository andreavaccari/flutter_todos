import 'package:equatable/equatable.dart';
import 'package:flutter_todos/models/models.dart';

abstract class FilteredTodosState extends Equatable {
  const FilteredTodosState();

  @override
  List<Object> get props => [];
}

class FilteredTodosLoadInProgress extends FilteredTodosState {}

class FilteredTodosLoadSuccess extends FilteredTodosState {
  final List<Todo> filteredTodos;
  final VisibilityFilter activeFilter;
  final String activeTodoId;

  const FilteredTodosLoadSuccess(
    this.filteredTodos,
    this.activeFilter, [
    this.activeTodoId,
  ]);

  @override
  List<Object> get props => [filteredTodos, activeFilter, activeTodoId];

  @override
  String toString() {
    return 'FilteredTodosLoadSuccess { filteredTodos: $filteredTodos, activeFilter: $activeFilter, activeTodoId: $activeTodoId }';
  }
}
