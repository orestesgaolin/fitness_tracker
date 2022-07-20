import 'package:database_client/database_client.dart';
import 'package:drift/drift.dart';

/// {@template steps_resource}
/// Resource exposing data from the [PedometerEntry] table
/// {@endtemplate}
class StepsResource {
  /// {@macro steps_resource}
  StepsResource(this._db);

  final DatabaseImplementation _db;

  /// Streams all the entries for a given day
  ///
  /// The entries are ordered by timestamp ascending
  Stream<List<PedometerEntry>> valuesForTheDay({
    required DateTime timestamp,
    int limit = 0,
    bool descending = false,
  }) {
    final mode = descending ? OrderingMode.desc : OrderingMode.asc;
    final query = _db.select(_db.pedometerEntryModel);

    final endDate = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
      23,
      59,
    );
    final startDate = DateTime(timestamp.year, timestamp.month, timestamp.day);

    query
      ..where((t) => t.timestamp.isBetweenValues(startDate, endDate))
      ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: mode)]);

    if (limit != 0) {
      query.limit(limit);
    }
    return query.watch();
  }

  /// Saves a new [PedometerEntry]
  Future<int> saveSteps(int value, DateTime timestamp) async {
    return _db.into(_db.pedometerEntryModel).insert(
          PedometerEntryModelCompanion(
            timestamp: Value(timestamp),
            value: Value(value),
          ),
        );
  }
}
