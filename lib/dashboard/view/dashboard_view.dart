import 'package:app_ui/app_ui.dart';
import 'package:fitness/dashboard/dashboard.dart';
import 'package:fitness/l10n/l10n.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardCubit>().state;
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      children: [
        Text(l10n.motivationalLabel),
        Text(l10n.yourAreas),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DashboardCard(
                    title: 'All Stats',
                    subtitle: 'See all of them',
                    color: AppColors.lightGrey,
                  ),
                  DashboardCard(
                    title: l10n.steps,
                    subtitle: l10n.stepsCount(state.steps),
                    emoji: '🚶‍♂️',
                    color: AppColors.blueBackground,
                  ),
                ],
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DashboardCard(
                    title: l10n.workout,
                    subtitle: l10n.addSession,
                    emoji: '🏋️‍♂️',
                    color: AppColors.pinkBackground,
                  ),
                  DashboardCard(
                    title: l10n.weight,
                    value: '69.9',
                    color: AppColors.yellowBackground,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
