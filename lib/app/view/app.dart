import 'package:fitness/home/home.dart';
import 'package:fitness/l10n/l10n.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
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
        theme: FlexThemeData.light(
          colors: const FlexSchemeColor(
            primary: Color(0xffffc4ff),
            primaryContainer: Color(0xffd0e4ff),
            secondary: Color(0xffac3306),
            secondaryContainer: Color(0xffffdbcf),
            tertiary: Color(0xff006875),
            tertiaryContainer: Color(0xff95f0ff),
            appBarColor: Color(0xffffdbcf),
            error: Color(0xffb00020),
          ),
          usedColors: 1,
          appBarOpacity: 0.95,
          subThemesData: const FlexSubThemesData(
            blendOnColors: false,
            textButtonRadius: 16,
            elevatedButtonRadius: 16,
            outlinedButtonRadius: 16,
            inputDecoratorIsFilled: false,
            inputDecoratorRadius: 16,
            chipRadius: 16,
            cardRadius: 16,
            popupMenuRadius: 12,
            dialogRadius: 16,
            timePickerDialogRadius: 16,
          ),
          useMaterial3ErrorColors: true,
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
          useMaterial3: true,
          fontFamily: 'OpenSans',
          textTheme: const TextTheme(
            bodyText2: TextStyle(
              package: 'app_ui',
              fontFamily: 'OpenSans',
            ),
          ),
        ),
        themeMode: ThemeMode.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
      ),
    );
  }
}
