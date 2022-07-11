import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:clock/clock.dart';
import 'package:equatable/equatable.dart';
import 'package:measurements_repository/measurements_repository.dart';

part 'weight_tracking_state.dart';

class WeightTrackingCubit extends Cubit<WeightTrackingState> {
  WeightTrackingCubit(this.measurementsRepository)
      : super(const WeightTrackingState([]));

  final MeasurementsRepository measurementsRepository;
  StreamSubscription<List<Weight>>? _listener;

  void init([TimeRange? range]) {
    final now = clock.now();
    final duration = (range ?? state.timeRange).duration();
    final startDate = duration != null ? now.subtract(duration) : DateTime(0);
    _listener = measurementsRepository
        .weights(startDate: startDate, endDate: now)
        .listen((weights) {
      emit(state.copyWith(weights: weights));
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
    _listener?.cancel();
    init(range);
  }

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }
}
