import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WeightChart extends StatelessWidget {
  const WeightChart({
    super.key,
    required this.weights,
  });

  final List<Weight> weights;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      legend: Legend(isVisible: false),
      plotAreaBorderWidth: 0,
      primaryYAxis: NumericAxis(
        axisLine: const AxisLine(
          color: Colors.transparent,
          width: 0,
        ),
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
        labelStyle: Theme.of(context)
            .textTheme
            .caption
            ?.copyWith(color: Colors.black38),
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
        labelStyle: Theme.of(context)
            .textTheme
            .caption
            ?.copyWith(color: Colors.black38),
        rangePadding: ChartRangePadding.round,
        interval: 2,
        borderWidth: 0,
      ),
      series: [
        SplineSeries<Weight, DateTime>(
          dataSource: weights,
          xValueMapper: (Weight weight, _) => weight.timestamp,
          yValueMapper: (Weight weight, _) => weight.value,
          isVisibleInLegend: false,
          splineType: SplineType.monotonic,
          markerSettings: MarkerSettings(
            isVisible: true,
            color: Theme.of(context).primaryColor.darken(),
            shape: DataMarkerType.circle,
            height: 4,
            width: 4,
          ),
          color: Theme.of(context).primaryColor.darken(),
        ),
      ],
    );
  }
}
