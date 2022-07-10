import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:measurements_repository/measurements_repository.dart';

part 'weight_tracking_state.dart';

class WeightTrackingCubit extends Cubit<WeightTrackingState> {
  WeightTrackingCubit(this.measurementsRepository)
      : super(const WeightTrackingState([]));

  final MeasurementsRepository measurementsRepository;
  StreamSubscription<List<Weight>>? _listener;

  void init([TimeRange? range]) {
    final now = DateTime.now();
    final duration = (range ?? state.timeRange).duration();
    final startDate = duration != null ? now.subtract(duration) : DateTime(0);
    _listener = measurementsRepository
        .weights(startDate: startDate, endDate: now)
        .listen((weights) {
      emit(state.copyWith(weights: weights));
    });
  }

  void addWeight(
    double? value, {
    DateTime? timestamp,
  }) {
    if (value != null) {
      measurementsRepository.saveWeight(
        Weight(
          value,
          timestamp ?? DateTime.now(),
        ),
      );
    }
  }

  void deleteEntry(int id) {
    measurementsRepository.deleteWeight(id: id);
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
