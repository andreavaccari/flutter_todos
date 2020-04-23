import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/blocs/todo/bloc.dart';
import 'package:todos_app_core/todos_app_core.dart';

import '../blocs/blocs.dart';

class TodoItem extends StatefulWidget {
  final DismissDirectionCallback onDismissed;
  // final GestureTapCallback onTap;
  // final ValueChanged<bool> onCheckboxChanged;

  TodoItem({
    Key key,
    @required this.onDismissed,
    // @required this.onTap,
    // @required this.onCheckboxChanged,
  }) : super(key: key);

  @override
  _TodoItemState createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.value = TextEditingValue(
        text: (context.bloc<TodoBloc>().state as TodoLoadSuccess).todo.task);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoBloc, TodoState>(
      listener: (context, state) {
        controller.value = TextEditingValue(
            text: (state as TodoLoadSuccess).todo.task,
            selection: controller.value.selection);
      },
      builder: (context, state) {
        if (state is TodoLoadInProgress) return Container();
        final stateLoaded = state as TodoLoadSuccess;
        return Dismissible(
          key: ArchSampleKeys.todoItem(stateLoaded.todo.id),
          onDismissed: widget.onDismissed,
          child: ListTile(
            trailing: Visibility(
              visible: stateLoaded.dirty,
              child: IconButton(
                icon: Icon(Icons.save),
                onPressed: context.bloc<TodoBloc>().todoSaved,
              ),
            ),
            title: TextField(
              style: stateLoaded.todo.complete
                  ? TextStyle(decoration: TextDecoration.lineThrough)
                  : null,
              controller: controller,
              onTap: () => context
                  .bloc<FilteredTodosBloc>()
                  .add(ActiveTodoChanged(stateLoaded.todo.id)),
              onChanged: context.bloc<TodoBloc>().todoTaskChanged,
            ),
          ),
        );
      },
    );
  }
}
