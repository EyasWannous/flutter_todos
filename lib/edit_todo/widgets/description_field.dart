import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todos/edit_todo/edit_todo.dart';

class DescriptionField extends StatelessWidget {
  const DescriptionField();

  @override
  Widget build(BuildContext context) {
    // final l10n = context.l10n;

    final state = context.watch<EditTodoBloc>().state;
    final hintText = state.initialTodo?.description ?? '';

    return TextFormField(
      key: const Key('editTodoView_description_textFormField'),
      initialValue: state.description,
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        enabled: !state.status.isLoadingOrSuccess,
        // labelText: l10n.editTodoDescriptionLabel,
        labelText: 'Description',
        hintText: hintText,
        icon: Icon(Icons.description),
      ),
      maxLength: 350,
      autocorrect: true,
      minLines: 1,
      maxLines: 8,
      inputFormatters: [
        LengthLimitingTextInputFormatter(350),
        FilteringTextInputFormatter.singleLineFormatter
      ],
      onChanged: (value) {
        context.read<EditTodoBloc>().add(EditTodoDescriptionChanged(value));
      },
    );
  }
}
