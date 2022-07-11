part of 'weight_tracking_cubit.dart';

class WeightTrackingState extends Equatable {
  const WeightTrackingState(
    this.weights, [
    this.averageWeights = const [],
    this.timeRange = TimeRange.last30Days,
  ]);

  final List<Weight> weights;
  final List<Weight> averageWeights;
  final TimeRange timeRange;

  @override
  List<Object> get props => [
        weights,
        averageWeights,
        timeRange,
      ];

  WeightTrackingState copyWith({
    List<Weight>? weights,
    List<Weight>? averageWeights,
    TimeRange? timeRange,
  }) {
    return WeightTrackingState(
      weights ?? this.weights,
      averageWeights ?? this.averageWeights,
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
