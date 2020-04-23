import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todos/blocs/todos/todos.dart';
import 'package:meta/meta.dart';

import '../../models/models.dart';
import '../todos/todos.dart';

part 'event.dart';
part 'event_completed_changed.dart';
part 'event_note_changed.dart';
part 'event_task_changed.dart';
part 'event_todo_saved.dart';
part 'state.dart';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

abstract class _TodoBloc extends Bloc<TodoEvent, TodoState> {
  final String id;
  final TodosBloc todosBloc;
  StreamSubscription todosSubscription;

  _TodoBloc({@required this.id, @required this.todosBloc}) {
    todosSubscription =
        todosBloc.listen((event) => add(_TodosStateUpdated(event)));
  }

  @override
  Future<void> close() {
    todosSubscription.cancel();
    return super.close();
  }

  @override
  TodoState get initialState {
    return todosBloc.state is TodosLoadInProgress
        ? TodoLoadInProgress()
        : _extractTodo(todosBloc.state);
  }

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is _TodosStateUpdated) {
      yield* _mapTodosUpdatedToState(event);
    } else {
      throw StateError('Unhandled event $event for state $state');
    }
  }

  Stream<TodoState> _mapTodosUpdatedToState(_TodosStateUpdated event) async* {
    if (event.state is TodosLoadInProgress) {
      yield TodoLoadInProgress();
    } else if (event.state is TodosLoadSuccess) {
      try {
        yield _extractTodo(event.state);
      } catch (_) {}
    }
  }

  TodoLoadSuccess _extractTodo(TodosState state) {
    return TodoLoadSuccess(
      (state as TodosLoadSuccess).todos.firstWhere((todo) => todo.id == id),
      dirty: false,
    );
  }
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

class TodoBloc = _TodoBloc
    with TaskChanged, NoteChanged, CompleteChanged, TodoSaved;
