import 'package:flutter/material.dart';

class AppButton extends ElevatedButton {
  const AppButton({
    required super.child,
    required super.onPressed,
    super.key,
  });
  AppButton.destructive({
    required super.child,
    required super.onPressed,
    required ThemeData theme,
    super.key,
  }) : super(
          style: ElevatedButton.styleFrom(
            primary: theme.colorScheme.tertiary,
          ),
        );
}
