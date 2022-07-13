import 'package:app_ui/app_ui.dart';
import 'package:fitness/l10n/l10n.dart';
import 'package:fitness/weight_edit/weight_edit.dart';
import 'package:fitness/weight_tracking/weight_tracking.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WeightTrackingView extends StatelessWidget {
  const WeightTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WeightTrackingCubit>().state;
    final l10n = context.l10n;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Stack(
              children: [
                Center(child: JumboLabel(l10n.bodyWeight)),
                Positioned(
                  right: 0,
                  child: Text(
                    'state: weights: ${state.weights.length}\n'
                    'averages: ${state.averageWeights.length}\n'
                    'timeRange: ${state.timeRange}\n',
                    style: const TextStyle(fontSize: 10),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            CardDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: SizedBox(
                height: 240,
                child: WeightChart(
                  weights: state.weights,
                  averageWeights: state.averageWeights,
                ),
              ),
            ),
            const TimeRangeSelector(),
            const Gap(8),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 150),
                itemCount: state.weights.length,
                itemBuilder: (context, index) {
                  final weight = state.weights[index];
                  final year =
                      weight.timestamp.year != DateTime.now().year ? ', y' : '';
                  final note = weight.note.isNotEmpty ? '• ${weight.note}' : '';
                  return ListTile(
                    onTap: () {
                      AppBottomSheet.present<void>(
                        context,
                        child: WeightEditPage.weight(
                          weight: weight,
                        ),
                      );
                    },
                    title: Text(
                      '${weight.value} kg$note',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      DateFormat('E, MMM d$year').format(weight.timestamp),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
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
