// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_client.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: type=lint
class WeightEntry extends DataClass implements Insertable<WeightEntry> {
  final int id;
  final double value;
  final DateTime timestamp;
  final DateTime created;
  WeightEntry(
      {required this.id,
      required this.value,
      required this.timestamp,
      required this.created});
  factory WeightEntry.fromData(Map<String, dynamic> data, {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return WeightEntry(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      value: const RealType()
          .mapFromDatabaseResponse(data['${effectivePrefix}value'])!,
      timestamp: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}timestamp'])!,
      created: const DateTimeType()
          .mapFromDatabaseResponse(data['${effectivePrefix}created'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['value'] = Variable<double>(value);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['created'] = Variable<DateTime>(created);
    return map;
  }

  WeightEntryModelCompanion toCompanion(bool nullToAbsent) {
    return WeightEntryModelCompanion(
      id: Value(id),
      value: Value(value),
      timestamp: Value(timestamp),
      created: Value(created),
    );
  }

  factory WeightEntry.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightEntry(
      id: serializer.fromJson<int>(json['id']),
      value: serializer.fromJson<double>(json['value']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      created: serializer.fromJson<DateTime>(json['created']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'value': serializer.toJson<double>(value),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'created': serializer.toJson<DateTime>(created),
    };
  }

  WeightEntry copyWith(
          {int? id, double? value, DateTime? timestamp, DateTime? created}) =>
      WeightEntry(
        id: id ?? this.id,
        value: value ?? this.value,
        timestamp: timestamp ?? this.timestamp,
        created: created ?? this.created,
      );
  @override
  String toString() {
    return (StringBuffer('WeightEntry(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('timestamp: $timestamp, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, value, timestamp, created);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightEntry &&
          other.id == this.id &&
          other.value == this.value &&
          other.timestamp == this.timestamp &&
          other.created == this.created);
}

class WeightEntryModelCompanion extends UpdateCompanion<WeightEntry> {
  final Value<int> id;
  final Value<double> value;
  final Value<DateTime> timestamp;
  final Value<DateTime> created;
  const WeightEntryModelCompanion({
    this.id = const Value.absent(),
    this.value = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.created = const Value.absent(),
  });
  WeightEntryModelCompanion.insert({
    this.id = const Value.absent(),
    required double value,
    required DateTime timestamp,
    this.created = const Value.absent(),
  })  : value = Value(value),
        timestamp = Value(timestamp);
  static Insertable<WeightEntry> custom({
    Expression<int>? id,
    Expression<double>? value,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? created,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (value != null) 'value': value,
      if (timestamp != null) 'timestamp': timestamp,
      if (created != null) 'created': created,
    });
  }

  WeightEntryModelCompanion copyWith(
      {Value<int>? id,
      Value<double>? value,
      Value<DateTime>? timestamp,
      Value<DateTime>? created}) {
    return WeightEntryModelCompanion(
      id: id ?? this.id,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
      created: created ?? this.created,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (created.present) {
      map['created'] = Variable<DateTime>(created.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightEntryModelCompanion(')
          ..write('id: $id, ')
          ..write('value: $value, ')
          ..write('timestamp: $timestamp, ')
          ..write('created: $created')
          ..write(')'))
        .toString();
  }
}

class $WeightEntryModelTable extends WeightEntryModel
    with TableInfo<$WeightEntryModelTable, WeightEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightEntryModelTable(this.attachedDatabase, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double?> value = GeneratedColumn<double?>(
      'value', aliasedName, false,
      type: const RealType(), requiredDuringInsert: true);
  final VerificationMeta _timestampMeta = const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime?> timestamp = GeneratedColumn<DateTime?>(
      'timestamp', aliasedName, false,
      type: const IntType(), requiredDuringInsert: true);
  final VerificationMeta _createdMeta = const VerificationMeta('created');
  @override
  late final GeneratedColumn<DateTime?> created = GeneratedColumn<DateTime?>(
      'created', aliasedName, false,
      type: const IntType(),
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, value, timestamp, created];
  @override
  String get aliasedName => _alias ?? 'weight_entry_model';
  @override
  String get actualTableName => 'weight_entry_model';
  @override
  VerificationContext validateIntegrity(Insertable<WeightEntry> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('created')) {
      context.handle(_createdMeta,
          created.isAcceptableOrUnknown(data['created']!, _createdMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    return WeightEntry.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $WeightEntryModelTable createAlias(String alias) {
    return $WeightEntryModelTable(attachedDatabase, alias);
  }
}

abstract class _$DatabaseClient extends GeneratedDatabase {
  _$DatabaseClient(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $WeightEntryModelTable weightEntryModel =
      $WeightEntryModelTable(this);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [weightEntryModel];
}
