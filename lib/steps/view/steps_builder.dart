import 'package:background_job_repository/background_job_repository.dart';
import 'package:fitness/steps/steps.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:permissions_repository/permissions_repository.dart';

typedef StepsBuilderCallback = Widget Function(
  BuildContext context,
  int stepsCount,
  bool permissionsGranted,
);

class StepsBuilder extends StatelessWidget {
  const StepsBuilder({super.key, required this.builder});

  final StepsBuilderCallback builder;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StepsCubit(
        context.read<PermissionsRepository>(),
        context.read<MeasurementsRepository>(),
        context.read<BackgroundJobRepository>(),
      ),
      child: Builder(
        builder: (context) {
          final value = context.watch<StepsCubit>().state;
          return builder(context, value.count, value.permissionsGranted);
        },
      ),
    );
  }
}
