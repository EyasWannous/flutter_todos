import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/edit_todo/edit_todo.dart';

import 'package:flutter_todos/edit_todo/widgets/widgets.dart';

class EditTodoView extends StatelessWidget {
  const EditTodoView({super.key});

  @override
  Widget build(BuildContext context) {
    // final l10n = context.l10n;
    final status = context.select((EditTodoBloc bloc) => bloc.state.status);
    final isNewTodo = context.select(
      (EditTodoBloc bloc) => bloc.state.isNewTodo,
    );
    final pickedTime = context.select(
      (EditTodoBloc bloc) => bloc.state.pickedDateTime,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          // isNewTodo
          //     ? l10n.editTodoAddAppBarTitle
          //     : l10n.editTodoEditAppBarTitle,
          isNewTodo ? 'Add Todo' : 'Edit Todo',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: context.read<EditTodoBloc>().formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          "https://www.projoodle.com/landing/img/todo-list-wizard.png",
                      progressIndicatorBuilder: (_, __, downloadProgress) =>
                          CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                      errorWidget: (_, __, ___) => Icon(Icons.error),
                      width: 75,
                      height: 150,
                    ),
                    Text(
                      'Add Todo to your list',
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.blueGrey),
                    ),
                  ],
                ),
                TitleField(),
                DescriptionField(),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: PickerField(
                    picked: pickedTime,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // tooltip: l10n.editTodoSaveButtonTooltip,
        tooltip: 'Save changes',
        shape: const ContinuousRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        onPressed: status.isLoadingOrSuccess
            ? null
            : () {
                if (context.read<EditTodoBloc>().checkValidation()) {
                  context.read<EditTodoBloc>().add(const EditTodoSubmitted());
                }
              },
        child: status.isLoadingOrSuccess
            ? const CupertinoActivityIndicator()
            : const Icon(Icons.check_rounded),
      ),
    );
  }
}
