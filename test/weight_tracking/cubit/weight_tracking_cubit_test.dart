// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, lines_longer_than_80_chars

import 'package:bloc_test/bloc_test.dart';
import 'package:clock/clock.dart';
import 'package:fitness/weight_tracking/cubit/weight_tracking_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockMeasurementsRepository extends Mock
    implements MeasurementsRepository {}

void main() {
  group('WeightTrackingCubit', () {
    late MeasurementsRepository measurementsRepository;
    final now = DateTime(2022, 6, 2);
    final todayWeight = Weight(4, now);
    final yearAgoAlmost = now.subtract(Duration(days: 350));
    final defaultWeights = [
      Weight(1, yearAgoAlmost),
      Weight(2, yearAgoAlmost.add(Duration(days: 1))),
      Weight(3, yearAgoAlmost.add(Duration(days: 1))),
      todayWeight,
    ];
    final averageWeights = [
      Weight(1, yearAgoAlmost),
      Weight(4, now.subtract(Duration(days: 1))),
      Weight(4, now),
    ];

    setUpAll(() {
      registerFallbackValue(Weight(1, DateTime(2000)));
    });

    setUp(() {
      measurementsRepository = MockMeasurementsRepository();
      when(() => measurementsRepository.latestWeight())
          .thenAnswer((_) => Stream.value(WeightProgress(10, 9.9)));
      when(() => measurementsRepository.saveWeight(any()))
          .thenAnswer((_) async {});
      when(
        () => measurementsRepository.weights(
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer(
        (_) => Stream.value(
          defaultWeights,
        ),
      );
    });

    blocTest<WeightTrackingCubit, WeightTrackingState>(
      'initial state is WeightTrackingState',
      build: () => WeightTrackingCubit(measurementsRepository),
      expect: () => <WeightTrackingState>[],
      verify: (b) => b.state == WeightTrackingState(const []),
    );

    blocTest<WeightTrackingCubit, WeightTrackingState>(
      'weights are emitted after calling init',
      build: () => withClock(
        Clock.fixed(now),
        () => WeightTrackingCubit(measurementsRepository)..init(),
      ),
      wait: Duration(milliseconds: 100),
      expect: () => <WeightTrackingState>[
        WeightTrackingState(defaultWeights),
        WeightTrackingState(defaultWeights, averageWeights),
      ],
      verify: (b) {
        verify(
          () => measurementsRepository.weights(
            startDate: now.subtract(Duration(days: 30)),
            endDate: now,
          ),
        ).called(1);
      },
    );

    group('addWeight', () {
      blocTest<WeightTrackingCubit, WeightTrackingState>(
        'calls saveWeight on the measurementsRepository',
        build: () => WeightTrackingCubit(measurementsRepository),
        act: (b) async {
          await b.addWeight(21, timestamp: DateTime(2022));
        },
        verify: (b) {
          verify(
            () => measurementsRepository.saveWeight(
              Weight(21, DateTime(2022)),
            ),
          );
        },
      );
    });

    group('changeTimeRange', () {
      blocTest<WeightTrackingCubit, WeightTrackingState>(
        'changes the timeRange and updates the weights',
        build: () => WeightTrackingCubit(measurementsRepository)..init(),
        act: (b) async {
          // b.init();
          // let the stream emit value
          await Future<void>.delayed(Duration(milliseconds: 100));

          b.changeTimeRange(TimeRange.lastYear);
        },
        wait: Duration(milliseconds: 100),
        expect: () => <WeightTrackingState>[
          WeightTrackingState(defaultWeights),
          WeightTrackingState(defaultWeights, averageWeights),
          WeightTrackingState([], [], TimeRange.lastYear),
          WeightTrackingState(defaultWeights, [], TimeRange.lastYear),
          WeightTrackingState(
            defaultWeights,
            averageWeights,
            TimeRange.lastYear,
          ),
        ],
      );
    });
  });
}
