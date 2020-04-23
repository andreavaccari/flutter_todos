import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_todos/blocs/filtered_todos/filtered_todos.dart';
import 'package:flutter_todos/blocs/todos/todos.dart';
import 'package:flutter_todos/models/models.dart';
import 'package:meta/meta.dart';

import '../todos/todos.dart';
import 'filtered_todos_event.dart';
import 'filtered_todos_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final TodosBloc todosBloc;
  StreamSubscription todosSubscription;

  FilteredTodosBloc({@required this.todosBloc}) {
    todosSubscription = todosBloc.listen((state) {
      if (state is TodosLoadSuccess) {
        add(TodosUpdated((todosBloc.state as TodosLoadSuccess).todos));
      }
    });
  }

  @override
  FilteredTodosState get initialState {
    return todosBloc.state is TodosLoadSuccess
        ? FilteredTodosLoadSuccess(
            (todosBloc.state as TodosLoadSuccess).todos,
            VisibilityFilter.all,
          )
        : FilteredTodosLoadInProgress();
  }

  @override
  Stream<FilteredTodosState> mapEventToState(FilteredTodosEvent event) async* {
    if (event is TodosUpdated) {
      yield* _mapTodosUpdatedToState(event);
    } else if (event is FilterUpdated) {
      yield* _mapFilterUpdatedToState(event);
    } else if (event is ActiveTodoChanged) {
      yield* _mapActiveTodoChangedToState(event);
    } else if (event is ActiveTodoToggled) {
      yield* _mapActiveTodoToggledToState();
    }
  }

  Stream<FilteredTodosState> _mapTodosUpdatedToState(
    TodosUpdated event,
  ) async* {
    final visibilityFilter = state is FilteredTodosLoadSuccess
        ? (state as FilteredTodosLoadSuccess).activeFilter
        : VisibilityFilter.all;
    final activeTodoId = state is FilteredTodosLoadSuccess
        ? (state as FilteredTodosLoadSuccess).activeTodoId
        : null;
    yield FilteredTodosLoadSuccess(
      _mapTodosToFilteredTodos(
        (todosBloc.state as TodosLoadSuccess).todos,
        visibilityFilter,
      ),
      visibilityFilter,
      activeTodoId,
    );
  }

  Stream<FilteredTodosState> _mapFilterUpdatedToState(
    FilterUpdated event,
  ) async* {
    if (todosBloc.state is TodosLoadSuccess) {
      yield FilteredTodosLoadSuccess(
        _mapTodosToFilteredTodos(
          (todosBloc.state as TodosLoadSuccess).todos,
          event.filter,
        ),
        event.filter,
        (state as FilteredTodosLoadSuccess).activeTodoId,
      );
    }
  }

  Stream<FilteredTodosState> _mapActiveTodoChangedToState(
    ActiveTodoChanged event,
  ) async* {
    if (todosBloc.state is TodosLoadSuccess) {
      yield FilteredTodosLoadSuccess(
        _mapTodosToFilteredTodos(
          (todosBloc.state as TodosLoadSuccess).todos,
          (state as FilteredTodosLoadSuccess).activeFilter,
        ),
        (state as FilteredTodosLoadSuccess).activeFilter,
        event.todoId,
      );
    }
  }

  Stream<FilteredTodosState> _mapActiveTodoToggledToState() async* {
    if (todosBloc.state is TodosLoadSuccess) {
      final loadedState = state as FilteredTodosLoadSuccess;
      final activeTodo = loadedState.filteredTodos.firstWhere(
          (todo) => todo.id == loadedState.activeTodoId,
          orElse: () => null);

      todosBloc.add(
          TodoUpdated(activeTodo.copyWith(complete: !activeTodo.complete)));
    }
  }

  List<Todo> _mapTodosToFilteredTodos(
      List<Todo> todos, VisibilityFilter filter) {
    return todos.where((todo) {
      if (filter == VisibilityFilter.all) {
        return true;
      } else if (filter == VisibilityFilter.active) {
        return !todo.complete;
      } else {
        return todo.complete;
      }
    }).toList();
  }

  @override
  Future<void> close() {
    todosSubscription.cancel();
    return super.close();
  }
}
