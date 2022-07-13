import 'package:app_ui/app_ui.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightChart extends StatelessWidget {
  WeightChart({
    super.key,
    required this.weights,
    required this.averageWeights,
  }) {
    timeSpan = weights.lastOrNull?.timestamp.difference(
          weights.firstOrNull?.timestamp ?? weights.last.timestamp,
        ) ??
        Duration.zero;
  }

  /// Handy getter to get 5% of the timespan in [Duration]
  Duration get fivePercentOfTimeSpan => Duration(days: timeSpan.inDays ~/ 20);

  /// The overall timespan of the data in [weights]
  late final Duration timeSpan;

  final List<Weight> weights;
  final List<Weight> averageWeights;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.caption?.copyWith(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.38),
        );
    final intervalType = timeSpan.inDays > 30
        ? timeSpan.inDays > 365
            ? DateTimeIntervalType.years
            : DateTimeIntervalType.months
        : DateTimeIntervalType.days;
    final interval = timeSpan.inDays > 30
        ? timeSpan.inDays > 365
            ? 1.0
            : 1.0
        : 2.0;
    return SfCartesianChart(
      key: UniqueKey(),
      legend: Legend(isVisible: false),
      plotAreaBorderWidth: 0,
      margin: EdgeInsets.zero,
      primaryYAxis: NumericAxis(
        isVisible: true,
        tickPosition: TickPosition.inside,
        edgeLabelPlacement: EdgeLabelPlacement.hide,
        axisLine: const AxisLine(
          color: Colors.transparent,
          width: 0,
        ),
        labelPosition: ChartDataLabelPosition.inside,
        minorGridLines: const MinorGridLines(width: 0),
        majorGridLines: const MajorGridLines(
          width: 0.5,
          color: Colors.black12,
          dashArray: [
            2,
            2,
          ],
        ),
        majorTickLines: const MajorTickLines(size: 0),
        labelStyle: labelStyle,
        borderWidth: 0,
        decimalPlaces: 1,
      ),
      primaryXAxis: DateTimeAxis(
        axisLine: const AxisLine(
          color: Colors.transparent,
          width: 0,
        ),
        minorGridLines: const MinorGridLines(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 4),
        labelStyle: labelStyle,
        rangePadding: ChartRangePadding.normal,
        maximum: weights.isNotEmpty
            ? weights.last.timestamp.add(fivePercentOfTimeSpan)
            : null,
        labelIntersectAction: AxisLabelIntersectAction.hide,
        edgeLabelPlacement: EdgeLabelPlacement.hide,
        borderWidth: 0,
        interval: interval,
        intervalType: intervalType,
      ),
      series: [
        SplineAreaSeries<Weight, DateTime>(
          dataSource: averageWeights,
          xValueMapper: (Weight weight, _) => weight.timestamp,
          yValueMapper: (Weight weight, _) => weight.value,
          isVisibleInLegend: false,
          color: Theme.of(context).primaryColor.darken(),
          borderWidth: 1,
          splineType: SplineType.natural,
          borderColor: Theme.of(context).primaryColor.darken(),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        ScatterSeries<Weight, DateTime>(
          dataSource: weights,
          xValueMapper: (Weight weight, _) => weight.timestamp,
          yValueMapper: (Weight weight, _) => weight.value,
          isVisibleInLegend: false,
          markerSettings: MarkerSettings(
            isVisible: true,
            color: Theme.of(context).primaryColor.darken(),
            shape: DataMarkerType.circle,
            height: 6,
            width: 6,
            borderWidth: 1,
          ),
          color: Theme.of(context).primaryColor.darken(),
          borderWidth: 1,
          borderColor: Theme.of(context).primaryColor.darken(),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ],
    );
  }
}
