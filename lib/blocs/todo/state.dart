part of 'bloc.dart';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

class TodoLoadInProgress extends TodoState {}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

class TodoLoadSuccess extends TodoState {
  final Todo todo;
  final bool dirty;

  const TodoLoadSuccess(this.todo, {this.dirty});

  @override
  List<Object> get props => [todo, dirty];

  @override
  String toString() => 'TodoLoadSuccess { todo: $todo, dirty: $dirty }';
}
