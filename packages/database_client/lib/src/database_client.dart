// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';

part 'database_client.g.dart';

/// {@template database_client}
/// Package connecting to the local database
/// {@endtemplate}
@DriftDatabase(tables: [WeightEntryModel, SettingsEntryModel])
class DatabaseClient extends _$DatabaseClient {
  /// {@macro database_client}
  DatabaseClient(File file) : super(NativeDatabase(file));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // we added the [SettingsEntryModel]
          await m.createTable(settingsEntryModel);
        }
      },
    );
  }

  Stream<List<WeightEntry>> weightEntries({
    DateTime? startDate,
    DateTime? endDate,
    int limit = 0,
    bool descending = false,
  }) {
    final mode = descending ? OrderingMode.desc : OrderingMode.asc;
    final query = select(weightEntryModel);

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

  Future<int> saveWeight(double value, DateTime timestamp) async {
    return into(weightEntryModel).insert(
      WeightEntryModelCompanion(
        value: Value(value),
        timestamp: Value(timestamp),
      ),
    );
  }

  Future<int> deleteWeight({required int id}) {
    return (delete(weightEntryModel)..where((tbl) => tbl.id.equals(id))).go();
  }

  Stream<Map<String, String>> settingsEntries() {
    final query = select(settingsEntryModel);

    return query.watch().map(
          (event) => {for (final v in event) v.key: v.value},
        );
  }

  Future<void> saveSettings(Map<String, String> settings) async {
    for (final setting in settings.entries) {
      await into(settingsEntryModel).insertOnConflictUpdate(
        SettingsEntry(key: setting.key, value: setting.value),
      );
    }
  }
}

@DataClassName('WeightEntry')
class WeightEntryModel extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get value => real()();
  DateTimeColumn get timestamp => dateTime()();
  DateTimeColumn get created => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('SettingsEntry')
class SettingsEntryModel extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
