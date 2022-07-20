import 'dart:async';

import 'package:background_job_repository/background_job_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:permissions_repository/permissions_repository.dart';

part 'steps_state.dart';

class StepsCubit extends Cubit<StepsState> {
  StepsCubit(
    this.permissionsRepository,
    this.measurementsRepository,
    this.backgroundJobRepository,
  ) : super(const StepsState()) {
    _permissionListener =
        permissionsRepository.hasAccessToActivity().listen((event) {
      emit(state.copyWith(permissionsGranted: event));
    });
    _stepsListener = measurementsRepository.todaySteps().listen((event) {
      emit(state.copyWith(count: event.count));
    });
    _deviceSensorListener =
        measurementsRepository.latestSteps().listen(saveSteps);
    backgroundJobRepository.schedulePedometerRegistration();
  }

  late StreamSubscription<bool> _permissionListener;
  late StreamSubscription<Steps> _stepsListener;
  late StreamSubscription<Steps> _deviceSensorListener;

  final PermissionsRepository permissionsRepository;
  final MeasurementsRepository measurementsRepository;
  final BackgroundJobRepository backgroundJobRepository;

  Future<void> saveSteps(Steps steps) async {
    try {
      await measurementsRepository.saveSteps(steps);
    } catch (e, s) {
      addError(e, s);
    }
  }

  @override
  Future<void> close() {
    _permissionListener.cancel();
    _stepsListener.cancel();
    _deviceSensorListener.cancel();
    return super.close();
  }
}
