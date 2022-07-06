part of 'dashboard_cubit.dart';

class DashboardState extends Equatable {
  const DashboardState({
    this.steps = 0,
    this.weight = 0,
    this.hasWorkoutSession = false,
  });

  final int steps;
  final double weight;
  final bool hasWorkoutSession;

  @override
  List<Object> get props => [
        steps,
        weight,
        hasWorkoutSession,
      ];
}
