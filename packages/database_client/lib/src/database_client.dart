// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'database_client.g.dart';

/// {@template database_client}
/// Package connecting to the local database
/// {@endtemplate}
@DriftDatabase(tables: [WeightEntryModel])
class DatabaseClient extends _$DatabaseClient {
  /// {@macro database_client}
  DatabaseClient(File file) : super(NativeDatabase(file));

  @override
  int get schemaVersion => 1;

  Stream<List<WeightEntry>> weightEntries({
    int limit = 0,
    bool descending = false,
  }) {
    final mode = descending ? OrderingMode.desc : OrderingMode.asc;
    final query = select(weightEntryModel)
      ..orderBy([(t) => OrderingTerm(expression: t.timestamp, mode: mode)]);
    if (limit != 0) {
      query.limit(limit);
    }
    return query.watch();
  }

  Future<int> saveWeight(double value, DateTime timestamp) async {
    return into(weightEntryModel).insert(
      WeightEntryModelCompanion(
        value: Value(value),
        timestamp: Value(timestamp),
      ),
    );
  }
}

@DataClassName('WeightEntry')
class WeightEntryModel extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get value => real()();
  DateTimeColumn get timestamp => dateTime()();
  DateTimeColumn get created => dateTime().withDefault(currentDateAndTime)();
}
