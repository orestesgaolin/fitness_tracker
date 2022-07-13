import 'package:fitness/weight_edit/weight_edit.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:measurements_repository/measurements_repository.dart';

class WeightEditPage extends StatelessWidget {
  const WeightEditPage.weight({
    super.key,
    required this.weight,
  });

  final Weight weight;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeightEditCubit.weight(
        weight: weight,
        measurementsRepository: context.read<MeasurementsRepository>(),
      ),
      child: const WeightEditView(),
    );
  }
}
