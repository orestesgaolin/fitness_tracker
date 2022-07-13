part of 'weight_edit_cubit.dart';

abstract class WeightEditState extends Equatable {
  const WeightEditState();
}

class WeightEditLoadingState extends WeightEditState {
  const WeightEditLoadingState(this.id);
  final int id;

  @override
  List<Object?> get props => [id];
}

class WeightPopulatedState extends WeightEditState {
  const WeightPopulatedState(this.weight);

  final Weight weight;

  @override
  List<Object> get props => [weight];
}
