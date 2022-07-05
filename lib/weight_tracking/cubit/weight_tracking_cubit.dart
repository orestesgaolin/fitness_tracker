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

  void init() {
    _listener = measurementsRepository.weights().listen((weights) {
      emit(WeightTrackingState(weights));
    });
  }

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
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
}
