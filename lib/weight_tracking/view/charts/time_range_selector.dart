import 'package:fitness/l10n/l10n.dart';
import 'package:fitness/weight_tracking/weight_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeRangeSelector extends StatelessWidget {
  const TimeRangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final timeRange = context.watch<WeightTrackingCubit>().state.timeRange;
    final rangeOrder = [
      TimeRange.last30Days,
      TimeRange.lastYear,
      TimeRange.allTime
    ];
    final l10n = context.l10n;
    return ToggleButtons(
      isSelected: [
        timeRange == rangeOrder[0],
        timeRange == rangeOrder[1],
        timeRange == rangeOrder[2],
      ],
      onPressed: (index) {
        final range = rangeOrder[index];
        context.read<WeightTrackingCubit>().changeTimeRange(range);
      },
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(l10n.last30Days),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(l10n.lastYear),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(l10n.allTime),
        ),
      ],
    );
  }
}
