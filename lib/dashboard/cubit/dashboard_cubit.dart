import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:measurements_repository/measurements_repository.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required this.measurementsRepository})
      : super(DashboardState());

  final MeasurementsRepository measurementsRepository;
  StreamSubscription<Weight?>? _weightListener;

  void init() {
    _weightListener = measurementsRepository.latestWeight().listen((weights) {
      if (weights != null) {
        emit(state.copyWith(weight: weights.value));
      }
    });
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  @override
  Future<void> close() {
    _weightListener?.cancel();
    return super.close();
  }
}
