part of 'settings_cubit.dart';

class SettingsState extends Equatable {
  const SettingsState({this.themeMode = ThemeMode.system});

  SettingsState.fromSettings(Settings settings)
      : this(
          themeMode: ThemeMode.values[settings.themeModeIndex],
        );

  final ThemeMode themeMode;

  SettingsState copyWith({ThemeMode? themeMode}) {
    return SettingsState(themeMode: themeMode ?? this.themeMode);
  }

  Settings toSettings() {
    return Settings(themeModeIndex: themeMode.index);
  }

  @override
  List<Object> get props => [themeMode];
}
