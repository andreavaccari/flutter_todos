import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/blocs/blocs.dart';
import 'package:flutter_todos/localization.dart';
import 'package:flutter_todos/models/models.dart';
import 'package:flutter_todos/widgets/toggle_button.dart';
import 'package:flutter_todos/widgets/widgets.dart';
import 'package:todos_app_core/todos_app_core.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TabBloc, AppTab>(
      builder: (context, activeTab) {
        return GestureDetector(
          onTap: () {
            final currentNode = FocusScope.of(context);
            if (!currentNode.hasPrimaryFocus) {
              currentNode.unfocus();
            }
            context.bloc<FilteredTodosBloc>().add(ActiveTodoChanged(null));
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text(FlutterBlocLocalizations.of(context).appTitle),
              actions: [
                ToggleButton(visible: activeTab == AppTab.todos),
                FilterButton(visible: activeTab == AppTab.todos),
                ExtraActions(),
              ],
            ),
            body: activeTab == AppTab.todos ? FilteredTodos() : Stats(),
            floatingActionButton: FloatingActionButton(
              key: ArchSampleKeys.addTodoFab,
              onPressed: () {
                Navigator.pushNamed(context, ArchSampleRoutes.addTodo);
              },
              child: Icon(Icons.add),
              tooltip: ArchSampleLocalizations.of(context).addTodo,
            ),
            bottomNavigationBar: TabSelector(
              activeTab: activeTab,
              onTabSelected: (tab) =>
                  BlocProvider.of<TabBloc>(context).add(TabUpdated(tab)),
            ),
          ),
        );
      },
    );
  }
}
