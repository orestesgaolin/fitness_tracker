// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

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
    this.valueUnit,
  });

  final String title;
  final String? subtitle;
  final String? emoji;
  final String? value;
  final String? valueUnit;
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    AutoSizeText(
                      value!,
                      style: const TextStyle(fontSize: 45),
                      maxLines: 1,
                    ),
                    if (valueUnit != null) Text(valueUnit!)
                  ],
                ),
              HeaderLabel(title),
              const Gap(6),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.3),
                    fontWeight: FontWeight.w500,
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
    this.margin = const EdgeInsets.all(8),
    this.padding = EdgeInsets.zero,
  });

  final Widget child;
  final Color color;
  final EdgeInsets margin;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
