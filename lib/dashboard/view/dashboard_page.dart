import 'package:fitness/dashboard/dashboard.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measurements_repository/measurements_repository.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DashboardCubit(
        measurementsRepository: context.read<MeasurementsRepository>(),
      )..init(),
      child: const DashboardView(),
    );
  }
}
