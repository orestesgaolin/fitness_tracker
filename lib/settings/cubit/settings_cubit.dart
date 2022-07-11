import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:settings_repository/settings_repository.dart';

part 'settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this.settingsRepository, Settings initialSettings)
      : super(SettingsState.fromSettings(initialSettings));

  final SettingsRepository settingsRepository;
  StreamSubscription<Settings>? _listener;

  void init() {
    _listener = settingsRepository.settings().listen((event) {
      emit(SettingsState.fromSettings(event));
    });
  }

  void toggleTheme(ThemeMode themeMode) {
    emit(state.copyWith(themeMode: themeMode));
    settingsRepository.saveSettings(state.toSettings());
  }

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }
}
