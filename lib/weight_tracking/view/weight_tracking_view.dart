import 'package:fitness/weight_tracking/weight_tracking.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class WeightTrackingView extends StatelessWidget {
  const WeightTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<WeightTrackingCubit>();
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cubit.state.weights.length,
            itemBuilder: (context, index) {
              final weight = cubit.state.weights[index];
              return ListTile(
                title: Text('Weight: ${weight.value}'),
              );
            },
          ),
        ),
        TextField(
          keyboardType: TextInputType.number,
          onSubmitted: (value) {
            cubit.addWeight(double.tryParse(value));
          },
        )
      ],
    );
  }
}
