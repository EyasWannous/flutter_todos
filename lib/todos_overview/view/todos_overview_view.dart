import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/edit_todo/view/edit_todo_page.dart';
import 'package:flutter_todos/todos_overview/todos_overview.dart';

class TodosOverviewView extends StatelessWidget {
  const TodosOverviewView({super.key});

  @override
  Widget build(BuildContext context) {
    // final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        // title: Text(l10n.todosOverviewAppBarTitle),
        title: const Text('Flutter Todos'),
        actions: [
          TodosOverviewFilterButton(),
          TodosOverviewOptionsButton(),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              if (state.status == TodosOverviewStatus.failure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('An error occurred while loading todos.'),
                      // content: Text(l10n.todosOverviewErrorSnackbarText),
                    ),
                  );
              }
            },
          ),
          BlocListener<TodosOverviewBloc, TodosOverviewState>(
            listenWhen: (previous, current) =>
                previous.lastDeletedTodo != current.lastDeletedTodo &&
                current.lastDeletedTodo != null,
            listener: (context, state) {
              final deletedTodo = state.lastDeletedTodo!;
              final messenger = ScaffoldMessenger.of(context);
              messenger
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text('Todo ${deletedTodo.title} deleted.'),
                    action: SnackBarAction(
                      // label: l10n.todosOverviewUndoDeletionButtonText,
                      label: 'Undo',
                      onPressed: () {
                        messenger.hideCurrentSnackBar();
                        context
                            .read<TodosOverviewBloc>()
                            .add(const TodosOverviewUndoDeletionRequested());
                      },
                    ),
                  ),
                );
            },
          ),
        ],
        child: BlocBuilder<TodosOverviewBloc, TodosOverviewState>(
          builder: (context, state) {
            if (state.todos.isEmpty) {
              if (state.status == TodosOverviewStatus.loading) {
                return const Center(child: CupertinoActivityIndicator());
              } else if (state.status != TodosOverviewStatus.success) {
                return const SizedBox();
              }
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        'assets/images/todos.jpg',
                        width: 250,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      // l10n.todosOverviewEmptyText,
                      'No todos found with the selected filters.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: state.filteredTodos.length,
              itemBuilder: (context, index) => TodoListTile(
                todo: state.filteredTodos.elementAt(index),
                pickedDateTime:
                    state.filteredTodos.elementAt(index).endDateTime,
                onToggleCompleted: (isCompleted) {
                  context.read<TodosOverviewBloc>().add(
                        TodosOverviewTodoCompletionToggled(
                          todo: state.filteredTodos.elementAt(index),
                          isCompleted: isCompleted,
                        ),
                      );
                },
                onDismissed: (_) {
                  context.read<TodosOverviewBloc>().add(
                        TodosOverviewTodoDeleted(
                          state.filteredTodos.elementAt(index),
                        ),
                      );
                },
                onTap: () {
                  Navigator.of(context).push(
                    EditTodoPage.route(
                      initialTodo: state.filteredTodos.elementAt(index),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
