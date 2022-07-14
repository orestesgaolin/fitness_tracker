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
    this.note = '',
    this.created,
  });

  /// Creates the [Weight] from the database's [WeightEntry]
  Weight.fromDatabase(WeightEntry weightEntry)
      : this(
          weightEntry.value,
          weightEntry.timestamp,
          id: weightEntry.id,
          note: weightEntry.note,
          created: weightEntry.created,
        );

  /// Mass in kg
  final double value;

  /// Time for which this entry was taken.
  ///
  /// Please note, that we may only care about the day part
  /// of the DateTime.
  final DateTime timestamp;

  /// Note related to measurement
  final String note;

  /// Creation timestamp
  final DateTime? created;

  /// Database id of the entry
  final int? id;

  /// Returns a copy of the entry
  Weight copyWith({
    DateTime? timestamp,
    double? value,
    String? note,
  }) {
    return Weight(
      value ?? this.value,
      timestamp ?? this.timestamp,
      id: id,
      note: note ?? this.note,
      created: created,
    );
  }

  @override
  List<Object?> get props => [
        value,
        timestamp,
        id,
        note,
        created,
      ];
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
    return const [];
  }
  if (weights.length == 1) {
    return const [];
  }
  if (weights.length == 2) {
    return weights;
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
  results.add(Weight(weights.first.value, minDate));

  if (timeSpan > const Duration(days: 30)) {
    final grouped = weights.groupListsBy<DateTime>(
      (element) => DateTime(
        element.timestamp.year,
        element.timestamp.month,
      ),
    );

    for (final group in grouped.entries) {
      if (group.key.isBetween(minDate, maxDate)) {
        final weight = Weight(
          group.value.map((e) => e.value).average,
          group.key,
        );
        results.add(weight);
      }
    }
  } else {
    final grouped = weights.groupListsBy(
      (element) => YearAndWeek(
        element.timestamp.year,
        element.timestamp.weekOfYear,
      ),
    );
    for (final group in grouped.entries) {
      if (group.key.date.isBetween(minDate, maxDate)) {
        final weight = Weight(
          group.value.map((e) => e.value).average,
          group.key.date,
        );
        results.add(weight);
      }
    }
  }
  if (results.last.timestamp.isBefore(maxDate)) {
    final lastAverage = (results.last.value + weights.last.value) / 2;
    if (!results.last.timestamp.isAtSameMomentAs(maxDate)) {
      results.add(Weight(lastAverage, maxDate));
    }
  }

  return results;
}

/// {@template year_and_week}
/// Utility class to wrap a [DateTime] with
/// the information about the year and week number
/// {@endtemplate}
class YearAndWeek extends Equatable {
  /// {@macro year_and_week}
  const YearAndWeek(this.year, this.week);

  // ignore: public_member_api_docs
  final int year;
  // ignore: public_member_api_docs
  final int week;

  /// Returns the original [DateTime] for a given instance
  DateTime get date => DateTime(year)
      .add(Duration(days: (week - 1) * 7))
      .add(const Duration(days: 3));

  @override
  List<Object?> get props => [
        year,
        week,
      ];
}

extension on DateTime {
  /// Checks if date is between [start] and [end] inclusive
  bool isBetween(DateTime start, DateTime end) {
    return isAtSameMomentAs(start) ||
        (isAfter(start) && isBefore(end)) ||
        isAtSameMomentAs(end);
  }

  /// The ISO 8601 week of year [1..53].
  ///
  /// Algorithm from https://en.wikipedia.org/wiki/ISO_week_date#Algorithms
  int get weekOfYear {
    // Add 3 to always compare with January 4th, which is always in week 1
    // Add 7 to index weeks starting with 1 instead of 0
    final woy = (ordinalDate - weekday + 10) ~/ 7;

    // If the week number equals zero, it means that the given date belongs
    // to the preceding (week-based) year.
    if (woy == 0) {
      // The 28th of December is always in the last week of the year
      return DateTime(year - 1, 12, 28).weekOfYear;
    }

    // If the week number equals 53, one must check that the date
    // is not actually in week 1 of the following year
    if (woy == 53 &&
        DateTime(year).weekday != DateTime.thursday &&
        DateTime(year, 12, 31).weekday != DateTime.thursday) {
      return 1;
    }

    return woy;
  }

  /// The ordinal date, the number of days since December 31st
  /// the previous year.
  ///
  /// January 1st has the ordinal date 1
  ///
  /// December 31st has the ordinal date 365, or 366 in leap years
  int get ordinalDate {
    const offsets = [0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334];
    return offsets[month - 1] + day + (isLeapYear && month > 2 ? 1 : 0);
  }

  /// True if this date is on a leap year.
  bool get isLeapYear {
    return year % 4 == 0 && (year % 100 != 0 || year % 400 == 0);
  }
}
