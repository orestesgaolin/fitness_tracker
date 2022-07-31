import 'package:database_client/database_client.dart';
import 'package:drift/drift.dart';

/// {@template exercises_resource}
/// Resource exposing data from the [ExerciseEntry] table
/// {@endtemplate}
class ExercisesResource {
  /// {@macro exercises_resource}
  ExercisesResource(this._db);

  final DatabaseImplementation _db;

  /// Streams all the entries for a given day
  ///
  /// The entries are ordered by timestamp ascending
  Stream<List<ExerciseEntry>> valuesForTheDay({
    required DateTime timestamp,
    int limit = 0,
    bool descending = false,
  }) {
    final mode = descending ? OrderingMode.desc : OrderingMode.asc;
    final query = _db.select(_db.exerciseEntryModel);

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

  /// Saves a new [ExerciseEntry]
  Future<int> saveExercise(
    String name,
    String note,
    DateTime timestamp,
    Duration duration,
    String type,
  ) async {
    return _db.into(_db.exerciseEntryModel).insert(
          ExerciseEntryModelCompanion(
            timestamp: Value(timestamp),
            name: Value(name),
            note: Value(note),
            duration: Value(duration.inSeconds),
            type: Value(type),
          ),
        );
  }
}
