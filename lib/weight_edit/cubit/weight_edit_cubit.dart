import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:measurements_repository/measurements_repository.dart';

part 'weight_edit_state.dart';

class WeightEditCubit extends Cubit<WeightEditState> {
  WeightEditCubit.weight({
    required Weight weight,
    required this.measurementsRepository,
  }) : super(WeightPopulatedState(weight)) {
    if (weight.id != null) {
      _init(weight.id!);
    }
  }

  WeightEditCubit.id({
    required int id,
    required this.measurementsRepository,
  }) : super(WeightEditLoadingState(id)) {
    _init(id);
  }

  StreamSubscription<Weight>? _listener;

  void _init(int id) {
    _listener?.cancel();
    _listener = measurementsRepository.getWeight(id).listen((event) {
      emit(WeightPopulatedState(event));
    });
  }

  final MeasurementsRepository measurementsRepository;

  void delete() {
    if (state is WeightPopulatedState) {
      final weight = (state as WeightPopulatedState).weight;
      measurementsRepository.deleteWeight(id: weight.id!);
    }
  }

  void update(double value) {
    if (state is WeightPopulatedState) {
      final weight = (state as WeightPopulatedState).weight;
      final updated = weight.copyWith(value: value);
      measurementsRepository.updateWeight(weight: updated);
    }
  }

  void updateNote(String value) {
    if (state is WeightPopulatedState) {
      final weight = (state as WeightPopulatedState).weight;
      final updated = weight.copyWith(note: value.trim());
      measurementsRepository.updateWeight(weight: updated);
    }
  }

  @override
  Future<void> close() {
    _listener?.cancel();
    return super.close();
  }
}
