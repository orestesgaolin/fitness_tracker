import 'package:app_ui/app_ui.dart';
import 'package:fitness/home/home.dart';
import 'package:fitness/l10n/l10n.dart';
import 'package:fitness/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measurements_repository/measurements_repository.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    required this.measurementsRepository,
  });

  final MeasurementsRepository measurementsRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: measurementsRepository),
      ],
      child: BlocProvider(
        create: (context) => SettingsCubit(),
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
