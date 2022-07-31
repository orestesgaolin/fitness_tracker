// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:database_client/database_client.dart';
import 'package:drift/drift.dart';
import 'package:drift/isolate.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;

part 'database_client.g.dart';

class DatabaseClient {
  DatabaseClient(File file) : _db = DatabaseImplementation(file);

  DatabaseClient.background(File file)
      : _db = DatabaseImplementation.connect(file);

  final DatabaseImplementation _db;

  WeightResource get weightResource => WeightResource(_db);

  SettingsResource get settingsResource => SettingsResource(_db);

  StepsResource get stepsResource => StepsResource(_db);

  static const defaultDatabaseName = 'db.sqlite';

  static File defaultDatabaseFile(String appPath) => File(
        path.join(
          appPath,
          DatabaseClient.defaultDatabaseName,
        ),
      );

  Future<void> close() {
    return _db.close();
  }
}

/// {@template database_implementation}
/// Package connecting to the local database
/// {@endtemplate}
@DriftDatabase(
  tables: [
    WeightEntryModel,
    SettingsEntryModel,
    ExerciseEntryModel,
    PedometerEntryModel,
  ],
)
class DatabaseImplementation extends _$DatabaseImplementation {
  /// {@macro database_implementation}
  DatabaseImplementation(File file) : super(NativeDatabase(file));

  DatabaseImplementation.connect(File file)
      : super.connect(DatabaseConnection.fromExecutor(NativeDatabase(file)));

  @override
  int get schemaVersion => 5;

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
        if (from < 3) {
          await m.addColumn(weightEntryModel, weightEntryModel.note);
          await m.createTable(exerciseEntryModel);
        }
        if (from < 4) {
          await m.createTable(pedometerEntryModel);
        }
        if (from < 5) {
          await m.addColumn(exerciseEntryModel, exerciseEntryModel.duration);
          await m.addColumn(exerciseEntryModel, exerciseEntryModel.type);
        }
      },
    );
  }
}

@DataClassName('WeightEntry')
class WeightEntryModel extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get value => real()();
  DateTimeColumn get timestamp => dateTime()();
  DateTimeColumn get created => dateTime().withDefault(currentDateAndTime)();
  TextColumn get note => text().withDefault(const Constant(''))();
}

@DataClassName('SettingsEntry')
class SettingsEntryModel extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('ExerciseEntry')
class ExerciseEntryModel extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get duration => integer().withDefault(const Constant(0))();
  DateTimeColumn get created => dateTime().withDefault(currentDateAndTime)();
  TextColumn get note => text().withDefault(const Constant(''))();
  TextColumn get type => text().nullable()();
}

@DataClassName('PedometerEntry')
class PedometerEntryModel extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get value => integer()();
}
