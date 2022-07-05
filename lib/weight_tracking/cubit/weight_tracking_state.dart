part of 'weight_tracking_cubit.dart';

class WeightTrackingState extends Equatable {
  const WeightTrackingState(this.weights);

  final List<Weight> weights;

  @override
  List<Object> get props => [weights];
}
