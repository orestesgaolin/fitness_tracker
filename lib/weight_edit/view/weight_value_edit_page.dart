import 'package:fitness/weight_tracking/weight_tracking.dart';
import 'package:flutter/material.dart';

class WeightValueEditPage extends StatelessWidget {
  const WeightValueEditPage({
    super.key,
    required this.initialWeight,
  });

  final double? initialWeight;

  @override
  Widget build(BuildContext context) {
    return WeightSelectionLayout(
      initialWeight: initialWeight ?? 70.0,
      onChanged: (value, dateTime) {},
      onSubmitted: (value, dateTime) {
        Navigator.of(context).pop(value);
      },
    );
  }
}
