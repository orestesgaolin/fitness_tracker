import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_bottom_bar}
/// Widget used as bottom navigation bar, wrapping the children with
/// black rounded background.
/// {@endtemplate}
class AppBottomBar extends StatelessWidget {
  /// {@macro app_bottom_bar}
  const AppBottomBar({
    super.key,
    required this.children,
    required this.selectedIndex,
  });

  /// List of icons shown in the bar
  final List<Widget> children;

  /// Index of the selected child
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Material(
        color: AppColors.blackBackground,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < children.length; i++)
                IconTheme(
                  data: IconTheme.of(context).copyWith(
                    color: selectedIndex == i
                        ? Colors.white
                        : AppColors.disabledIconWhite,
                  ),
                  child: children[i],
                )
            ],
          ),
        ),
      ),
    );
  }
}
