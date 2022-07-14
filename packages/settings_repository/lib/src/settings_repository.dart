// ignore_for_file: public_member_api_docs

import 'package:database_client/database_client.dart';

/// {@template settings_repository}
/// Repository accessing the settings
/// {@endtemplate}
class SettingsRepository {
  /// {@macro settings_repository}
  const SettingsRepository(this.settingsResource);

  final SettingsResource settingsResource;

  Stream<Settings> settings() {
    return settingsResource.settingsEntries().map(
          (event) => Settings(
            themeModeIndex: int.tryParse(event['themeModeIndex'] ?? '0') ?? 0,
          ),
        );
  }

  Future<void> saveSettings(Settings settings) async {
    await settingsResource.saveSettings(settings.toMap());
  }
}

/// {@template settings}
/// Model storing the app-wide settings
/// {@endtemplate}
class Settings {
  /// {@macro settings}
  Settings({
    required this.themeModeIndex,
  });

  /// Index of the `ThemeMode` selected by the user
  final int themeModeIndex;

  Map<String, String> toMap() {
    return {
      'themeModeIndex': themeModeIndex.toString(),
    };
  }
}
