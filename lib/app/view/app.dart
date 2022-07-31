import 'package:app_ui/app_ui.dart';
import 'package:background_job_repository/background_job_repository.dart';
import 'package:files_repository/files_repository.dart';
import 'package:fitness/home/home.dart';
import 'package:fitness/l10n/l10n.dart';
import 'package:fitness/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:permissions_repository/permissions_repository.dart';
import 'package:settings_repository/settings_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.initialSettings,
    required this.measurementsRepository,
    required this.settingsRepository,
    required this.permissionsRepository,
    required this.backgroundJobRepository,
    required this.filesRepository,
  });

  final Settings initialSettings;
  final MeasurementsRepository measurementsRepository;
  final SettingsRepository settingsRepository;
  final PermissionsRepository permissionsRepository;
  final BackgroundJobRepository backgroundJobRepository;
  final FilesRepository filesRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: measurementsRepository),
        RepositoryProvider.value(value: settingsRepository),
        RepositoryProvider.value(value: permissionsRepository),
        RepositoryProvider.value(value: backgroundJobRepository),
        RepositoryProvider.value(value: filesRepository),
      ],
      child: BlocProvider(
        create: (context) =>
            SettingsCubit(settingsRepository, initialSettings)..init(),
        child: const AppWithTheme(),
      ),
    );
  }
}

class AppWithTheme extends StatelessWidget {
  const AppWithTheme({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HomePage(),
      themeMode:
          context.select<SettingsCubit, ThemeMode>((s) => s.state.themeMode),
    );
  }
}
