part of 'bloc.dart';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

class _TaskChanged extends TodoEvent {
  final String task;

  const _TaskChanged(this.task);

  @override
  List<Object> get props => [task];

  @override
  String toString() => 'TodoTaskChanged { task: $task }';
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

mixin TaskChanged on _TodoBloc {
  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is _TaskChanged && state is TodoLoadSuccess) {
      yield TodoLoadSuccess(
        (state as TodoLoadSuccess).todo.copyWith(task: event.task),
        dirty: true,
      );
    } else {
      yield* super.mapEventToState(event);
    }
  }

  void todoTaskChanged(String task) => add(_TaskChanged(task));
}
