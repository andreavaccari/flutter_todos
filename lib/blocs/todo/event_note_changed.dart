part of 'bloc.dart';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

class _NoteChanged extends TodoEvent {
  final String note;

  const _NoteChanged(this.note);

  @override
  List<Object> get props => [note];

  @override
  String toString() => 'TodoNoteChanged { note: $note }';
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

mixin NoteChanged on _TodoBloc {
  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is _NoteChanged && state is TodoLoadSuccess) {
      yield TodoLoadSuccess(
        (state as TodoLoadSuccess).todo.copyWith(note: event.note),
        dirty: true,
      );
    } else {
      yield* super.mapEventToState(event);
    }
  }

  void todoNoteChanged(String note) => add(_NoteChanged(note));
}
