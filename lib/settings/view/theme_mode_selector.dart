import 'package:fitness/l10n/l10n.dart';
import 'package:fitness/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeModeSelector extends StatelessWidget {
  const ThemeModeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SettingsCubit>().state;
    final l10n = context.l10n;
    final labels = {
      ThemeMode.dark: l10n.dark,
      ThemeMode.light: l10n.light,
      ThemeMode.system: l10n.system,
    };
    return PopupMenuButton<ThemeMode>(
      onSelected: (selection) {
        context.read<SettingsCubit>().toggleTheme(selection);
      },
      itemBuilder: (context) {
        return [
          PopupMenuItem(
            value: ThemeMode.light,
            child: Text(labels[ThemeMode.light]!),
          ),
          PopupMenuItem(
            value: ThemeMode.dark,
            child: Text(labels[ThemeMode.dark]!),
          ),
          PopupMenuItem(
            value: ThemeMode.system,
            child: Text(labels[ThemeMode.system]!),
          ),
        ];
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(labels[state.themeMode]!),
          const Icon(Icons.keyboard_arrow_down),
        ],
      ),
    );
  }
}
