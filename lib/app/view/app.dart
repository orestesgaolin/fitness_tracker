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
            primary: Color(0xffc4e7ff),
            primaryContainer: Color(0xffd0e4ff),
            secondary: Color(0xfff5bbeb),
            secondaryContainer: Color(0xffffdbcf),
            tertiary: Color(0xfffef5dd),
            tertiaryContainer: Color(0xff95f0ff),
            appBarColor: Color(0xffffdbcf),
            error: Color(0xffb00020),
          ),
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 20,
          appBarOpacity: 0.95,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 20,
            blendOnColors: false,
            textButtonRadius: 16,
            elevatedButtonRadius: 16,
            outlinedButtonRadius: 16,
            cardRadius: 16,
            dialogRadius: 16,
            timePickerDialogRadius: 16,
            elevatedButtonElevation: 0,
            dialogElevation: 0,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
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
          fontFamily: 'BarlowCondensed',
        ),
        darkTheme: FlexThemeData.dark(
          colors: const FlexSchemeColor(
            primary: Color(0xff9fc9ff),
            primaryContainer: Color(0xff00325b),
            secondary: Color(0xffffb59d),
            secondaryContainer: Color(0xff872100),
            tertiary: Color(0xff86d2e1),
            tertiaryContainer: Color(0xff004e59),
            appBarColor: Color(0xff872100),
            error: Color(0xffcf6679),
          ),
          surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
          blendLevel: 15,
          appBarStyle: FlexAppBarStyle.background,
          appBarOpacity: 0.90,
          subThemesData: const FlexSubThemesData(
            blendOnLevel: 30,
            textButtonRadius: 16,
            elevatedButtonRadius: 16,
            outlinedButtonRadius: 16,
            cardRadius: 16,
            dialogRadius: 16,
            timePickerDialogRadius: 16,
            elevatedButtonElevation: 0,
            dialogElevation: 0,
          ),
          visualDensity: FlexColorScheme.comfortablePlatformDensity,
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
          fontFamily: 'BarlowCondensed',
        ),
        themeMode: ThemeMode.system,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const HomePage(),
      ),
    );
  }
}
