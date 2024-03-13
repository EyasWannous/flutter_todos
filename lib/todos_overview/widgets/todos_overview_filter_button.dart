import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/todos_overview/todos_overview.dart';

class TodosOverviewFilterButton extends StatelessWidget {
  const TodosOverviewFilterButton({super.key});

  @override
  Widget build(BuildContext context) {
    // final l10n = context.l10n;

    final activeFilter =
        context.select((TodosOverviewBloc bloc) => bloc.state.filter);

    return PopupMenuButton<TodosViewFilter>(
      shape: const ContinuousRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      initialValue: activeFilter,
      // tooltip: l10n.todosOverviewFilterTooltip,
      tooltip: 'Filter',
      onSelected: (filter) {
        context
            .read<TodosOverviewBloc>()
            .add(TodosOverviewFilterChanged(filter));
      },
      itemBuilder: (context) {
        return [
          const PopupMenuItem(
            value: TodosViewFilter.all,
            // child: Text(l10n.todosOverviewFilterAll),
            child: Text('All'),
          ),
          const PopupMenuItem(
            value: TodosViewFilter.activeOnly,
            // child: Text(l10n.todosOverviewFilterActiveOnly),
            child: Text('Active only'),
          ),
          const PopupMenuItem(
            value: TodosViewFilter.completedOnly,
            // child: Text(l10n.todosOverviewFilterCompletedOnly),
            child: Text('Completed only'),
          ),
        ];
      },
      icon: const Icon(Icons.filter_list_rounded),
    );
  }
}
