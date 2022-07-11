import 'package:app_ui/app_ui.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

final ThemeData lightTheme = FlexThemeData.light(
  colors: const FlexSchemeColor(
    primary: Color(0xffc4e7ff),
    primaryContainer: Color(0xffe1f0f5),
    secondary: Color(0xfff5bbeb),
    secondaryContainer: Color(0xffffeeee),
    tertiary: Color(0xfffef5dd),
    tertiaryContainer: Color(0xfffef5dd),
    appBarColor: Color(0xffffeeee),
    error: Color(0xffb00020),
  ),
  useMaterial3: true,
  blendLevel: 5,
  appBarOpacity: 0.95,
  surfaceTint: const Color(0xffe9f6ff),
  surface: AppColors.lightGrey,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 4,
    blendOnColors: false,
    textButtonRadius: 16,
    elevatedButtonRadius: 16,
    outlinedButtonRadius: 16,
    toggleButtonsRadius: 16,
    cardRadius: 16,
    dialogRadius: 16,
    timePickerDialogRadius: 16,
    elevatedButtonElevation: 0,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
).copyWith(
  textTheme: textTheme,
);
final ThemeData darkTheme = FlexThemeData.dark(
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
  useMaterial3: true,
  blendLevel: 5,
  appBarStyle: FlexAppBarStyle.background,
  appBarOpacity: 0.90,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 6,
    textButtonRadius: 16,
    elevatedButtonRadius: 16,
    outlinedButtonRadius: 16,
    toggleButtonsRadius: 16,
    cardRadius: 16,
    dialogRadius: 16,
    timePickerDialogRadius: 16,
    elevatedButtonElevation: 0,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
).copyWith(textTheme: darkTextTheme);
