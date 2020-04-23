import 'package:equatable/equatable.dart';
import 'package:flutter_todos/models/models.dart';

abstract class FilteredTodosEvent extends Equatable {
  const FilteredTodosEvent();

  @override
  List<Object> get props => [];
}

class TodosUpdated extends FilteredTodosEvent {
  final List<Todo> todos;

  const TodosUpdated(this.todos);

  @override
  List<Object> get props => [todos];

  @override
  String toString() => 'TodosUpdated { todos: $todos }';
}

class FilterUpdated extends FilteredTodosEvent {
  final VisibilityFilter filter;

  const FilterUpdated(this.filter);

  @override
  List<Object> get props => [filter];

  @override
  String toString() => 'FilterUpdated { filter: $filter }';
}

class ActiveTodoChanged extends FilteredTodosEvent {
  final String todoId;

  const ActiveTodoChanged(this.todoId);

  @override
  List<Object> get props => [todoId];

  @override
  String toString() => 'ActiveTodoChanged { todoId: $todoId }';
}

class ActiveTodoToggled extends FilteredTodosEvent {}
