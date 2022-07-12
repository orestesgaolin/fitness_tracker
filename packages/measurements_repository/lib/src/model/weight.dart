// ignore_for_file: cascade_invocations

import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:database_client/database_client.dart';
import 'package:equatable/equatable.dart';

/// {@template weight}
/// Model representing a single body weight entry.
/// {@endtemplate}
class Weight extends Equatable {
  /// {@macro weight}
  const Weight(
    this.value,
    this.timestamp, {
    this.id,
  });

  /// Creates the [Weight] from the database's [WeightEntry]
  Weight.fromDatabase(WeightEntry weightEntry)
      : this(
          weightEntry.value,
          weightEntry.timestamp,
          id: weightEntry.id,
        );

  /// Mass in kg
  final double value;

  /// Time for which this entry was taken.
  ///
  /// Please note, that we may only care about the day part
  /// of the DateTime.
  final DateTime timestamp;

  /// Database id of the entry
  final int? id;

  @override
  List<Object?> get props => [value, timestamp, id];
}

/// {@template weight_progress}
/// Utility class to inform was what the weight progress
/// between two most recent entries in the database.
/// {@endtemplate}
class WeightProgress extends Equatable {
  /// {@macro weight_progress}
  const WeightProgress(this.value, double? previousValue)
      : offset = value - (previousValue ?? value);

  /// Latest value
  final double value;

  /// Difference between latest and one before latest entry
  final double offset;

  @override
  List<Object?> get props => [value, offset];
}

/// Calculates the averages of values
/// and groups them into "reasonable" intervals
///
/// For durations longer than a month it will calculate
/// averages per month starting from the earliest date
///
/// For shorter time spans it will fit them into weeks.
List<Weight> averageWeights(List<Weight> weights) {
  if (weights.isEmpty) {
    return [];
  }
  if (weights.length == 1) {
    return [];
  }

  final minTimestamp =
      weights.map((e) => e.timestamp.millisecondsSinceEpoch).reduce(math.min);
  final minDate = DateTime.fromMillisecondsSinceEpoch(minTimestamp);
  final maxTimestamp =
      weights.map((e) => e.timestamp.millisecondsSinceEpoch).reduce(math.max);
  final maxDate = DateTime.fromMillisecondsSinceEpoch(maxTimestamp);

  final timeSpan = Duration(milliseconds: maxTimestamp - minTimestamp);

  final results = <Weight>[];

  // Start with the first entry
  results.add(weights.first);

  if (timeSpan > const Duration(days: 30)) {
    final grouped = weights.groupListsBy<DateTime>(
      (element) => DateTime(
        element.timestamp.year,
        element.timestamp.month,
      ),
    );

    for (final group in grouped.entries) {
      if (group.key.isAfter(minDate) && group.key.isBefore(maxDate)) {
        final weight = Weight(
          group.value.map((e) => e.value).average,
          group.key,
        );
        results.add(weight);
      }
    }
  } else {
    for (var date = DateTime.fromMillisecondsSinceEpoch(minTimestamp);
        date.millisecondsSinceEpoch < maxTimestamp;
        date = date.add(const Duration(days: 7))) {
      final entriesInWeek = weights.where(
        (element) => element.timestamp
            .isBetween(date, date.add(const Duration(days: 7))),
      );
      final average = entriesInWeek.map((e) => e.value).average;
      final averageDate = date.add(const Duration(days: 3, hours: 12));
      if (averageDate.isAfter(minDate) && averageDate.isBefore(maxDate)) {
        final weight = Weight(
          average,
          averageDate,
        );
        results.add(weight);
      }
    }
  }
  results.add(weights.last);

  return results;
}

extension on DateTime {
  bool isBetween(DateTime start, DateTime end) {
    return isAtSameMomentAs(start) ||
        (isAfter(start) && isBefore(end)) ||
        isAtSameMomentAs(end);
  }
}
