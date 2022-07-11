import 'dart:async';
import 'dart:math' as math;

import 'package:bloc/bloc.dart';
import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:measurements_repository/measurements_repository.dart';

part 'weight_tracking_state.dart';

class WeightTrackingCubit extends Cubit<WeightTrackingState> {
  WeightTrackingCubit(this.measurementsRepository)
      : super(const WeightTrackingState([]));

  final MeasurementsRepository measurementsRepository;
  StreamSubscription<List<Weight>>? _weightListener;

  void init([TimeRange? range]) {
    final now = clock.now();
    final duration = (range ?? state.timeRange).duration();
    final startDate = duration != null ? now.subtract(duration) : DateTime(0);
    _weightListener = measurementsRepository
        .weights(startDate: startDate, endDate: now)
        .listen((weights) async {
      emit(
        state.copyWith(
          weights: weights,
          averageWeights: [],
        ),
      );
      final averages = await compute(_computeAverages, weights);
      emit(state.copyWith(averageWeights: averages));
    });
  }

  Future<void> addWeight(
    double? value, {
    DateTime? timestamp,
  }) async {
    try {
      if (value != null) {
        await measurementsRepository.saveWeight(
          Weight(
            value,
            timestamp ?? clock.now(),
          ),
        );
      }
    } catch (e, s) {
      addError(e, s);
    }
  }

  void deleteEntry(int id) {
    try {
      measurementsRepository.deleteWeight(id: id);
    } catch (e, s) {
      addError(e, s);
    }
  }

  void changeTimeRange(TimeRange range) {
    emit(state.copyWith(timeRange: range));
    _weightListener?.cancel();
    init(range);
  }

  @override
  Future<void> close() {
    _weightListener?.cancel();
    return super.close();
  }
}

/// Calculates the averages of values
/// and groups them into "reasonable" intervals
List<Weight> _computeAverages(List<Weight> weights) {
  final minDate =
      weights.map((e) => e.timestamp.millisecondsSinceEpoch).reduce(math.min);
  final maxDate =
      weights.map((e) => e.timestamp.millisecondsSinceEpoch).reduce(math.max);
  final timeSpan = Duration(milliseconds: maxDate - minDate);
  final list = <Weight>[];
  if (timeSpan > const Duration(days: 30)) {
    final grouped = weights.groupListsBy<DateTime>(
      (element) => DateTime(
        element.timestamp.year,
        element.timestamp.month,
      ),
    );
    for (final group in grouped.entries) {
      final weight = Weight(
        group.value.map((e) => e.value).average,
        group.key,
      );
      list.add(weight);
    }
  } else {
    list.add(weights.first);
    for (var date = DateTime.fromMillisecondsSinceEpoch(minDate);
        date.millisecondsSinceEpoch < maxDate;
        date = date.add(const Duration(days: 7))) {
      final entriesInWeek = weights.where(
        (element) => element.timestamp
            .isBetween(date, date.add(const Duration(days: 7))),
      );
      final average = entriesInWeek.map((e) => e.value).average;
      list.add(
        Weight(
          average,
          date.add(
            const Duration(days: 3, hours: 12),
          ),
        ),
      );
    }
  }
  list.add(weights.last);

  return list;
}

extension on DateTime {
  bool isBetween(DateTime start, DateTime end) {
    return isAtSameMomentAs(start) ||
        (isAfter(start) && isBefore(end)) ||
        isAtSameMomentAs(end);
  }
}
