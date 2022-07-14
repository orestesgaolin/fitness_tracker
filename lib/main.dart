import 'dart:io';

import 'package:database_client/database_client.dart';
import 'package:fitness/app/app.dart';
import 'package:fitness/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:settings_repository/settings_repository.dart';

void main() {
  bootstrap(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(path.join(dbFolder.path, 'db.sqlite'));

    final databaseClient = DatabaseClient(file);
    final measurementsRepository =
        MeasurementsRepository(databaseClient.weightResource);
    final settingsRepository =
        SettingsRepository(databaseClient.settingsResource);
    final settings = await settingsRepository.settings().first;
    return App(
      initialSettings: settings,
      measurementsRepository: measurementsRepository,
      settingsRepository: settingsRepository,
    );
  });
}
