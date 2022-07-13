import 'package:fitness/weight_tracking/weight_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measurements_repository/measurements_repository.dart';

class WeightSelectionPage extends StatelessWidget {
  const WeightSelectionPage({
    super.key,
    required this.initialWeight,
  });

  final double? initialWeight;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeightTrackingCubit(
        context.read<MeasurementsRepository>(),
      ),
      child: Builder(
        builder: (context) {
          return WeightSelectionLayout(
            initialWeight: initialWeight ?? 70.0,
            onChanged: (value, dateTime) {},
            onSubmitted: (value, dateTime) {
              context
                  .read<WeightTrackingCubit>()
                  .addWeight(value, timestamp: dateTime);
              Navigator.of(context).maybePop();
            },
          );
        },
      ),
    );
  }
}
