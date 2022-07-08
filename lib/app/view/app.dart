import 'package:app_ui/app_ui.dart';
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
              secondary: Color(0xffc4e7ff),
              secondaryContainer: Color(0xffc4e7ff),
              tertiary: Color(0xfffef5dd),
              tertiaryContainer: Color(0xff95f0ff),
              appBarColor: Color(0xffc4e7ff),
              error: Color(0xffb00020),
            ),
            usedColors: 5,
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
            textTheme: TextTheme(
              headline1: AppTextStyle.headline1,
              headline2: AppTextStyle.headline2,
              headline3: AppTextStyle.headline3,
              headline4: AppTextStyle.headline4,
              headline5: AppTextStyle.headline5,
              subtitle1: AppTextStyle.subtitle1,
              subtitle2: AppTextStyle.subtitle2,
              bodyText1: AppTextStyle.bodyText1,
              bodyText2: AppTextStyle.bodyText2,
              caption: AppTextStyle.caption,
              overline: AppTextStyle.overline,
              button: AppTextStyle.button,
            ),
            fontFamily: 'BarlowCondensed'),
        themeMode: ThemeMode.light,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
      ),
    );
  }
}
