import 'package:background_job_repository/background_job_repository.dart';
import 'package:database_client/database_client.dart';
import 'package:fitness/app/app.dart';
import 'package:fitness/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permissions_repository/permissions_repository.dart';
import 'package:settings_repository/settings_repository.dart';

void main() {
  bootstrap(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = DatabaseClient.defaultDatabaseFile(dbFolder.path);

    final databaseClient = DatabaseClient(file);

    final permissionsRepository = PermissionsRepository();

    final measurementsRepository = MeasurementsRepository(
      databaseClient.weightResource,
      databaseClient.stepsResource,
    );
    final backgroundJobRepository = BackgroundJobRepository(file);

    final settingsRepository =
        SettingsRepository(databaseClient.settingsResource);
    final settings = await settingsRepository.settings().first;
    return App(
      initialSettings: settings,
      measurementsRepository: measurementsRepository,
      settingsRepository: settingsRepository,
      permissionsRepository: permissionsRepository,
      backgroundJobRepository: backgroundJobRepository,
    );
  });
}
