// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// {@template dashboard_card}
/// Card shown on the dashboard of the app
/// {@endtemplate}
class DashboardCard extends StatelessWidget {
  /// {@macro dashboard_app}
  const DashboardCard({
    super.key,
    required this.title,
    this.subtitle,
    this.emoji,
    this.value,
    required this.color,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final String? emoji;
  final String? value;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CardDecoration(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 32,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (emoji != null)
                Text(
                  emoji!,
                  style: const TextStyle(fontSize: 45),
                ),
              if (emoji != null) const Gap(12),
              if (value != null)
                AutoSizeText(
                  value!,
                  style: const TextStyle(fontSize: 45),
                  maxLines: 1,
                ),
              HeaderLabel(title),
              const Gap(6),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: const TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class CardDecoration extends StatelessWidget {
  const CardDecoration({
    super.key,
    required this.child,
    required this.color,
  });

  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: child,
      ),
    );
  }
}
