import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todos/theme/bloc/theme_helper.dart';
import 'package:flutter_todos/theme/theme.dart';

part 'theme_event.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeData> {
  ThemeBloc() : super(ThemeData.light()) {
    on<InitialThemeSetEvent>(_onInitialThemeSetEvent);
    on<ThemeSwitchEvent>(_onThemeSwitchEvent);
  }

  Future<void> _onInitialThemeSetEvent(event, emit) async {
    final bool hasDarkTheme = await isDark();
    if (hasDarkTheme) {
      emit(FlutterTodosTheme.dark);
      return;
    }

    emit(FlutterTodosTheme.light);
  }

  void _onThemeSwitchEvent(event, emit) {
    final isDark = state == FlutterTodosTheme.dark;
    emit(isDark ? FlutterTodosTheme.light : FlutterTodosTheme.dark);
    setTheme(isDark);
  }
}
