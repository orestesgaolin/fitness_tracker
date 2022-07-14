import 'package:database_client/database_client.dart';
import 'package:drift/drift.dart';

/// {@template weight_resource}
/// Resource exposing data from the [WeightEntry] table
/// {@endtemplate}
class WeightResource {
  /// {@macro weight_resource}
  WeightResource(this._db);

  final DatabaseImplementation _db;

  /// Exposes a stream of the [WeightEntry] between
  /// specified [startDate] and [endDate] inclusive
  Stream<List<WeightEntry>> weightEntries({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 0,
    bool descending = false,
  }) {
    final mode = descending ? OrderingMode.desc : OrderingMode.asc;
    final query = _db.select(_db.weightEntryModel);

    if (startDate != null && endDate != null) {
      query.where((t) => t.timestamp.isBetweenValues(startDate, endDate));
    } else if (startDate != null) {
      query.where((t) => t.timestamp.isBiggerOrEqualValue(startDate));
    } else if (endDate != null) {
      query.where((t) => t.timestamp.isSmallerOrEqualValue(startDate));
    }

    query.orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: mode)]);
    if (limit != 0) {
      query.limit(limit);
    }
    return query.watch();
  }

  /// Updates the specified [WeightEntry]
  Future<int> updateWeight(WeightEntry entry) {
    return (_db.update(_db.weightEntryModel)
          ..where((tbl) => tbl.id.equals(entry.id)))
        .write(entry);
  }

  /// Saves a new [WeightEntry]
  Future<int> saveWeight(double value, DateTime timestamp) async {
    return _db.into(_db.weightEntryModel).insert(
          WeightEntryModelCompanion(
            value: Value(value),
            timestamp: Value(timestamp),
          ),
        );
  }

  /// Deletes a specified [WeightEntry]
  Future<int> deleteWeight({required int id}) {
    return (_db.delete(_db.weightEntryModel)..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  /// Streams a specified [WeightEntry] by its id
  ///
  /// It will fail if there's no entry at a given id.
  /// If, at any point, the query emits no or more than
  /// one rows, an error will be added to the stream instead.
  Stream<WeightEntry> weightEntry({required int id}) {
    return (_db.select(_db.weightEntryModel)..where((tbl) => tbl.id.equals(id)))
        .watchSingle();
  }
}
