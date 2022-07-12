import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightChart extends StatelessWidget {
  const WeightChart({
    super.key,
    required this.weights,
    required this.averageWeights,
  });

  final List<Weight> weights;
  final List<Weight> averageWeights;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.caption?.copyWith(
          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.38),
        );
    return SfCartesianChart(
      key: UniqueKey(),
      legend: Legend(isVisible: false),
      plotAreaBorderWidth: 0,
      margin: EdgeInsets.zero,
      primaryYAxis: NumericAxis(
        // opposedPosition: true,
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
      ),
      primaryXAxis: DateTimeAxis(
        axisLine: const AxisLine(
          color: Colors.transparent,
          width: 0,
        ),
        minorGridLines: const MinorGridLines(width: 0),
        majorGridLines: const MajorGridLines(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        labelStyle: labelStyle,
        rangePadding: ChartRangePadding.round,
        labelIntersectAction: AxisLabelIntersectAction.hide,
        edgeLabelPlacement: EdgeLabelPlacement.hide,
        borderWidth: 0,
      ),
      series: [
        SplineAreaSeries<Weight, DateTime>(
          dataSource: averageWeights,
          xValueMapper: (Weight weight, _) => weight.timestamp,
          yValueMapper: (Weight weight, _) => weight.value,
          isVisibleInLegend: false,
          color: Theme.of(context).primaryColor.darken(),
          borderWidth: 1,
          splineType: SplineType.monotonic,
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
