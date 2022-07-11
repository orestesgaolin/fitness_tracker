import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:measurements_repository/measurements_repository.dart';

part 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit({required this.measurementsRepository})
      : super(DashboardState());

  final MeasurementsRepository measurementsRepository;
  StreamSubscription<WeightProgress?>? _weightListener;

  void init() {
    _weightListener = measurementsRepository.latestWeight().listen((weights) {
      emit(
        state.copyWith(
          weight: weights?.value,
          weightChange: weights?.offset,
        ),
      );
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
