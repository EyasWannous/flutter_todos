import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/theme/bloc/theme_bloc.dart';
import 'package:flutter_todos/theme/theme.dart';
import 'package:flutter_todos/todos_overview/todos_overview.dart';

@visibleForTesting
enum TodosOverviewOption { toggleAll, clearCompleted, swithTheme }

class TodosOverviewOptionsButton extends StatelessWidget {
  const TodosOverviewOptionsButton({super.key});

  @override
  Widget build(BuildContext context) {
    // final l10n = context.l10n;

    final todos = context.select((TodosOverviewBloc bloc) => bloc.state.todos);
    final hasTodos = todos.isNotEmpty;
    final completedTodosAmount = todos.where((todo) => todo.isCompleted).length;

    return PopupMenuButton<TodosOverviewOption>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      // tooltip: l10n.todosOverviewOptionsTooltip,
      tooltip: 'Options',
      onSelected: (options) {
        switch (options) {
          case TodosOverviewOption.toggleAll:
            context
                .read<TodosOverviewBloc>()
                .add(const TodosOverviewToggleAllRequested());
          case TodosOverviewOption.clearCompleted:
            context
                .read<TodosOverviewBloc>()
                .add(const TodosOverviewClearCompletedRequested());
          case TodosOverviewOption.swithTheme:
            context.read<ThemeBloc>().add(ThemeSwitchEvent());
        }
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: TodosOverviewOption.toggleAll,
            enabled: hasTodos,
            child: Text(
              // completedTodosAmount == todos.length
              //     ? l10n.todosOverviewOptionsMarkAllIncomplete
              //     : l10n.todosOverviewOptionsMarkAllComplete,
              completedTodosAmount == todos.length
                  ? 'Mark all as incomplete'
                  : 'Mark all as completed',
            ),
          ),
          PopupMenuItem(
            value: TodosOverviewOption.clearCompleted,
            enabled: hasTodos && completedTodosAmount > 0,
            // child: Text(l10n.todosOverviewOptionsClearCompleted),
            child: const Text('Clear completed'),
          ),
          PopupMenuItem(
            value: TodosOverviewOption.swithTheme,
            child: BlocBuilder<ThemeBloc, ThemeData>(
              builder: (_, themeData) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Change Theme'),
                    Icon(
                      themeData == FlutterTodosTheme.dark
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined,
                    ),
                  ],
                );
              },
            ),
          ),
        ];
      },
      icon: const Icon(Icons.more_vert_rounded),
    );
  }
}
