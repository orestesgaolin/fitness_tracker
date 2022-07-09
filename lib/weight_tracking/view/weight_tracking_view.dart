import 'package:fitness/weight_tracking/weight_tracking.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class WeightTrackingView extends StatelessWidget {
  const WeightTrackingView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<WeightTrackingCubit>();
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cubit.state.weights.length,
              itemBuilder: (context, index) {
                final weight = cubit.state.weights[index];
                return ListTile(
                  title: Text('Weight: ${weight.value}'),
                  subtitle: Text(
                    DateFormat('E, M/d, HH:mm').format(weight.timestamp),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
