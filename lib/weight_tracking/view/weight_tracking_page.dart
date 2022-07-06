import 'package:fitness/weight_tracking/weight_tracking.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measurements_repository/measurements_repository.dart';

class WeightTrackingPage extends StatelessWidget {
  const WeightTrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeightTrackingCubit(
        context.read<MeasurementsRepository>(),
      )..init(),
      child: const Scaffold(
        body: WeightTrackingView(),
      ),
    );
  }
}
