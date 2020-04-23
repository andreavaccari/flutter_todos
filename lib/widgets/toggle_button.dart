import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/blocs/filtered_todos/filtered_todos.dart';

import '../blocs/filtered_todos/filtered_todos_event.dart';
import '../blocs/filtered_todos/filtered_todos_state.dart';

class ToggleButton extends StatelessWidget {
  final bool visible;

  ToggleButton({this.visible, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilteredTodosBloc, FilteredTodosState>(
      builder: (context, state) {
        Widget button;

        if (state is FilteredTodosLoadInProgress) {
          button = Container();
        } else {
          final loadedState = state as FilteredTodosLoadSuccess;
          final activeTodo = loadedState.filteredTodos.firstWhere(
              (todo) => todo.id == loadedState.activeTodoId,
              orElse: () => null);

          if (activeTodo != null) {
            button = IconButton(
              onPressed: () {
                BlocProvider.of<FilteredTodosBloc>(context)
                    .add(ActiveTodoToggled());
              },
              icon: activeTodo.complete
                  ? Icon(Icons.check_box)
                  : Icon(Icons.check_box_outline_blank),
            );
          } else {
            return IconButton(
              onPressed: null,
              icon: Icon(Icons.indeterminate_check_box),
            );
          }
        }
        return AnimatedOpacity(
          opacity: visible ? 1.0 : 0.0,
          duration: Duration(milliseconds: 150),
          child: visible ? button : IgnorePointer(child: button),
        );
      },
    );
  }
}
