import 'package:flutter/widgets.dart';

/// Defines the color palette for the App UI.
abstract class AppColors {
  /// Black
  static const Color blackBackground = Color(0xFF242a2e);

  /// White
  static const Color white = Color(0xFFFFFFFF);

  /// Disabled icon white
  static const Color disabledIconWhite = Color(0xFF676c72);

  /// Transparent
  static const Color transparent = Color(0x00000000);

  /// Primary
  static const Color primary = Color(0xFFf5bbeb);

  /// Blue background
  static const Color blueBackground = Color(0xFFe1f0f5);

  /// Pink background
  static const Color pinkBackground = Color(0xFFffeeee);

  /// Yellow background
  static const Color yellowBackground = Color(0xFFfef5dd);

  /// Light grey background
  static const Color lightGrey = Color(0xFFf4f6f5);
}

extension ColorExt on Color {
  Color darken([double amount = .1]) {
    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }
}
