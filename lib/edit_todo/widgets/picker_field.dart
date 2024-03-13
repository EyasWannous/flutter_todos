import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:flutter_todos/edit_todo/edit_todo.dart';

class PickerField extends StatelessWidget {
  const PickerField({
    Key? key,
    this.picked,
  }) : super(key: key);

  final DateTime? picked;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.date_range_outlined),
        const SizedBox(width: 20.0),
        picked != null
            ? Text(
                "${DateFormat('yyyy-MM-dd HH:mm').format(picked!)}",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.pink.shade300),
              )
            : Text(
                "Select your deadline",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.pink.shade300),
              ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: ElevatedButton(
            onPressed: () =>
                context.read<EditTodoBloc>().selectDateTime(context),
            child: const Text('Select Date'),
          ),
        ),
      ],
    );
  }
}
