part of 'bloc.dart';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

class _CompleteChanged extends TodoEvent {
  final bool complete;

  const _CompleteChanged(this.complete);

  @override
  List<Object> get props => [complete];

  @override
  String toString() => 'CompleteChanged { completed: $complete }';
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

mixin CompleteChanged on _TodoBloc {
  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is _CompleteChanged && state is TodoLoadSuccess) {
      yield TodoLoadSuccess(
        (state as TodoLoadSuccess).todo.copyWith(complete: event.complete),
        dirty: true,
      );
    } else {
      yield* super.mapEventToState(event);
    }
  }

  void todoToggled(bool complete) => add(_CompleteChanged(complete));
}
