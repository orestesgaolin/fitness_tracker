import 'package:app_ui/app_ui.dart';
import 'package:fitness/dashboard/dashboard.dart';
import 'package:fitness/home/home.dart';
import 'package:fitness/l10n/l10n.dart';
import 'package:fitness/weight_tracking/weight_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<DashboardCubit>().state;
    final textScale = MediaQuery.of(context).textScaleFactor;
    final l10n = context.l10n;
    return ListView(
      padding: const EdgeInsets.only(bottom: 200),
      children: [
        const Gap(100),
        JumboLabel(l10n.motivationalLabel).paddedH(28),
        SizedBox(
          height: 70 * textScale,
          child: HorizontalCalendarListView(
            startDate: state.startDate,
            selectedDate: state.selectedDate,
            onTap: (date) {
              context.read<DashboardCubit>().selectDate(date);
            },
          ),
        ).paddedV(16),
        HeaderLabel(l10n.yourAreas).paddedH(32),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DashboardCard(
                    title: l10n.allStats,
                    subtitle: l10n.allStatsSubtitle,
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    onTap: () {
                      context.read<HomeCubit>().setPage(HomeSelection.activity);
                    },
                  ),
                  DashboardCard(
                    title: l10n.steps,
                    subtitle: l10n.stepsCount(3745),
                    emoji: '🚶‍♂️',
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ],
              ),
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DashboardCard(
                    title: '🗓 ${DateFormat.MEd().format(state.selectedDate)}',
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  DashboardCard(
                    title:
                        state.weight == null ? l10n.recordWeight : l10n.weight,
                    value: state.weight?.toStringAsFixed(1),
                    valueUnit: 'kg',
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    onTap: () {
                      AppBottomSheet.present<void>(
                        context,
                        child: WeightSelectionPage(
                          initialWeight: state.weight,
                        ),
                      );
                    },
                  ),
                  DashboardCard(
                    title: l10n.workout,
                    subtitle: l10n.addSession,
                    emoji: '🏋️‍♂️',
                    color: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                ],
              ),
            ),
          ],
        ).paddedH(24),
      ],
    );
  }
}
