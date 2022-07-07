// ignore_for_file: prefer_const_constructors

import 'package:bloc_test/bloc_test.dart';
import 'package:fitness/dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockMeasurementsRepository extends Mock
    implements MeasurementsRepository {}

void main() {
  group('DashboardCubitTest', () {
    late MeasurementsRepository measurementsRepository;

    setUp(() {
      measurementsRepository = MockMeasurementsRepository();
      when(() => measurementsRepository.latestWeight())
          .thenAnswer((invocation) => Stream.value(WeightProgress(10, 9.9)));
    });

    blocTest<DashboardCubit, DashboardState>(
      'emits WeightProgress when initialized',
      build: () =>
          DashboardCubit(measurementsRepository: measurementsRepository)
            ..init(),
      expect: () => [
        DashboardState(
          weight: 10,
          weightChange: 10.0 - 9.9,
        ),
      ],
    );

    blocTest<DashboardCubit, DashboardState>(
      'emits new selected date when selectDate called',
      build: () =>
          DashboardCubit(measurementsRepository: measurementsRepository),
      act: (cubit) => cubit.selectDate(DateTime(2020)),
      expect: () => [
        DashboardState(selectedDate: DateTime(2020)),
      ],
    );
  });
}
