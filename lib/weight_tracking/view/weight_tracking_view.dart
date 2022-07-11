import 'package:app_ui/app_ui.dart';
import 'package:fitness/l10n/l10n.dart';
import 'package:fitness/weight_tracking/weight_tracking.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WeightTrackingView extends StatelessWidget {
  const WeightTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<WeightTrackingCubit>();
    final weights = cubit.state.weights;
    final l10n = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            JumboLabel(l10n.bodyWeight),
            CardDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SizedBox(
                  height: 240,
                  child: WeightChart(weights: weights),
                ),
              ),
            ),
            const TimeRangeSelector(),
            Expanded(
              child: ListView.builder(
                itemCount: cubit.state.weights.length,
                itemBuilder: (context, index) {
                  final weight = cubit.state.weights[index];
                  return ListTile(
                    title: Text('${weight.value} kg'),
                    subtitle: Text(
                      DateFormat('E, M/d').format(weight.timestamp),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () {
                        cubit.deleteEntry(weight.id!);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
