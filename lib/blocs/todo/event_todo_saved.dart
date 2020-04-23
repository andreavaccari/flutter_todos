part of 'bloc.dart';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

class _TodoSaved extends TodoEvent {}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

mixin TodoSaved on _TodoBloc {
  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is _TodoSaved && state is TodoLoadSuccess) {
      yield TodoLoadSuccess(
        (state as TodoLoadSuccess).todo,
        dirty: false,
      );

      todosBloc.add(
        TodoUpdated((state as TodoLoadSuccess).todo),
      );
    } else {
      yield* super.mapEventToState(event);
    }
  }

  void todoSaved() => add(_TodoSaved());
}
