import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/theme/bloc/theme_bloc.dart';
import 'package:todos_repository/todos_repository.dart';

import 'app_view.dart';

class App extends StatelessWidget {
  const App({required this.todosRepository, super.key});

  final TodosRepository todosRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: todosRepository,
      child: BlocProvider<ThemeBloc>(
        create: (_) => ThemeBloc()..add(InitialThemeSetEvent()),
        child: const AppView(),
      ),
    );
  }
}
