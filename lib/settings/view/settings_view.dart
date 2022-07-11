import 'package:app_ui/app_ui.dart';
import 'package:fitness/l10n/l10n.dart';
import 'package:fitness/settings/settings.dart';
import 'package:flutter/material.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.only(bottom: 200, left: 12, right: 12),
      children: [
        const Gap(100),
        JumboLabel(l10n.settings).paddedH(16),
        ...ListTile.divideTiles(
          color: Theme.of(context).dividerColor,
          tiles: [
            ListTile(
              title: Text(l10n.themeMode),
              trailing: const ThemeModeSelector(),
            ),
            CheckboxListTile(
              value: false,
              onChanged: (_) {},
              title: Text(l10n.notifications),
            ),
          ],
        ),
      ],
    );
  }
}
