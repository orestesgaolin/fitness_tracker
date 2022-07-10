part of 'weight_tracking_cubit.dart';

class WeightTrackingState extends Equatable {
  const WeightTrackingState(
    this.weights, [
    this.timeRange = TimeRange.last30Days,
  ]);

  final List<Weight> weights;
  final TimeRange timeRange;

  @override
  List<Object> get props => [
        weights,
        timeRange,
      ];

  WeightTrackingState copyWith({
    List<Weight>? weights,
    TimeRange? timeRange,
  }) {
    return WeightTrackingState(
      weights ?? this.weights,
      timeRange ?? this.timeRange,
    );
  }
}

enum TimeRange {
  last30Days,
  lastYear,
  allTime;

  Duration? duration() {
    switch (this) {
      case TimeRange.last30Days:
        return const Duration(days: 30);
      case TimeRange.lastYear:
        return const Duration(days: 365);
      case TimeRange.allTime:
        return null;
    }
  }
}
