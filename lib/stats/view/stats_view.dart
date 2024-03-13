import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/stats/stats.dart';

class StatsView extends StatelessWidget {
  const StatsView({super.key});

  @override
  Widget build(BuildContext context) {
    // final l10n = context.l10n;
    final state = context.watch<StatsBloc>().state;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        // title: Text(l10n.statsAppBarTitle),
        title: const Text('Stats'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              key: const Key('statsView_completedTodos_listTile'),
              leading: const Icon(Icons.check_rounded),
              // title: Text(l10n.statsCompletedTodoCountLabel),
              title: const Text('Completed todos'),
              trailing: Text(
                '${state.completedTodos}',
                style: textTheme.headlineSmall,
              ),
            ),
            ListTile(
              key: const Key('statsView_activeTodos_listTile'),
              leading: const Icon(Icons.radio_button_unchecked_rounded),
              // title: Text(l10n.statsActiveTodoCountLabel),
              title: const Text('Active todos'),
              trailing: Text(
                '${state.activeTodos}',
                style: textTheme.headlineSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
