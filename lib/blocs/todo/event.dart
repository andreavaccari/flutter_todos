part of 'bloc.dart';

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - //

class _TodosStateUpdated extends TodoEvent {
  final TodosState state;

  const _TodosStateUpdated(this.state);

  @override
  List<Object> get props => [state];

  @override
  String toString() => 'TodosStateUpdated { state: $state }';
}
