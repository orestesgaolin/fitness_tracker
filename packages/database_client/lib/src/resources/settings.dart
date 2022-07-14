import 'package:database_client/database_client.dart';

/// {@template settings_resource}
/// Resource exposing the data from the [SettingsEntry] table
/// {@endtemplate}
class SettingsResource {
  /// {@macro settings_resource}
  SettingsResource(this._db);

  final DatabaseImplementation _db;

  /// Exposes the Map of settings
  ///
  /// Each entry in the table is stringified, thus it's mostly
  /// not type safe. It's the consumer of the stream that is
  /// responsible for correctly mapping the data to expected type.
  Stream<Map<String, String>> settingsEntries() {
    final query = _db.select(_db.settingsEntryModel);

    return query.watch().map(
          (event) => {for (final v in event) v.key: v.value},
        );
  }

  /// Saves the specified key and value Map into [SettingsEntry] table
  ///
  ///  If the insert would violate a primary key or uniqueness
  /// constraint, updates the columns that are present on given entry.
  Future<void> saveSettings(Map<String, String> settings) async {
    for (final setting in settings.entries) {
      await _db.into(_db.settingsEntryModel).insertOnConflictUpdate(
            SettingsEntry(key: setting.key, value: setting.value),
          );
    }
  }
}
