import 'package:fitness/l10n/l10n.dart';
import 'package:fitness/weight_tracking/weight_tracking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TimeRangeSelector extends StatelessWidget {
  const TimeRangeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final timeRange = context.watch<WeightTrackingCubit>().state.timeRange;

    final l10n = context.l10n;
    return CupertinoSlidingSegmentedControl<TimeRange>(
      groupValue: timeRange,
      onValueChanged: (index) {
        if (index != null) {
          context.read<WeightTrackingCubit>().changeTimeRange(index);
        }
      },
      children: {
        TimeRange.last30Days: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(l10n.last30Days),
        ),
        TimeRange.lastYear: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(l10n.lastYear),
        ),
        TimeRange.allTime: Padding(
          padding: const EdgeInsets.all(8),
          child: Text(l10n.allTime),
        )
      },
    );
  }
}
