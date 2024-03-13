import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:todos_repository/todos_repository.dart';

part 'edit_todo_event.dart';
part 'edit_todo_state.dart';

class EditTodoBloc extends Bloc<EditTodoEvent, EditTodoState> {
  EditTodoBloc({
    required TodosRepository todosRepository,
    required Todo? initialTodo,
  })  : _todosRepository = todosRepository,
        super(
          EditTodoState(
            initialTodo: initialTodo,
            title: initialTodo?.title ?? '',
            description: initialTodo?.description ?? '',
            pickedDateTime: initialTodo?.endDateTime,
          ),
        ) {
    on<EditTodoTitleChanged>(_onTitleChanged);
    on<EditTodoDescriptionChanged>(_onDescriptionChanged);
    on<EditTodoDate>(_onDateTimeChanged);
    on<EditTodoSubmitted>(_onSubmitted);
  }

  final TodosRepository _todosRepository;

  void _onTitleChanged(
    EditTodoTitleChanged event,
    Emitter<EditTodoState> emit,
  ) =>
      emit(state.copyWith(title: event.title));

  void _onDescriptionChanged(
    EditTodoDescriptionChanged event,
    Emitter<EditTodoState> emit,
  ) =>
      emit(state.copyWith(description: event.description));

  void _onDateTimeChanged(
    EditTodoDate event,
    Emitter<EditTodoState> emit,
  ) =>
      emit(state.copyWith(pickedDateTime: event.pickedDateTime));

  Future<void> _onSubmitted(
    EditTodoSubmitted event,
    Emitter<EditTodoState> emit,
  ) async {
    emit(state.copyWith(status: EditTodoStatus.loading));
    final todo = (state.initialTodo ?? Todo(title: '')).copyWith(
      title: state.title,
      description: state.description,
      endDateTime: state.pickedDateTime,
    );

    try {
      await _todosRepository.saveTodo(todo);
      emit(state.copyWith(status: EditTodoStatus.success));
    } catch (e) {
      emit(state.copyWith(status: EditTodoStatus.failure));
    }
  }

  // Form
  final formKey = GlobalKey<FormState>();

  bool checkValidation() => formKey.currentState!.validate();

  // Time Picker
  Future<void> selectDateTime(BuildContext context) async {
    await _selectDate(context);
    await _selectTime(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: state.pickedDateTime ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked == null || picked == state.pickedDateTime) return;
    add(EditTodoDate(picked));
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: state.pickedDateTime == null
          ? TimeOfDay.now()
          : TimeOfDay.fromDateTime(state.pickedDateTime!),
    );

    if (pickedTime == null) return;
    if (pickedTime == TimeOfDay.fromDateTime(state.pickedDateTime!)) return;

    add(
      EditTodoDate(
        state.pickedDateTime!.add(
          Duration(
            hours: pickedTime.hour,
            minutes: pickedTime.minute,
          ),
        ),
      ),
    );
  }
}
