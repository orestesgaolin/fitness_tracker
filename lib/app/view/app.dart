import 'package:fitness/l10n/l10n.dart';
import 'package:fitness/weight_tracking/weight_tracking.dart';
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
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
          colorScheme: ColorScheme.fromSwatch(
            accentColor: const Color(0xFF13B9FF),
          ),
        ),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const WeightTrackingPage(),
      ),
    );
  }
}
