// ignore_for_file: public_member_api_docs

import 'package:database_client/database_client.dart';
import 'package:equatable/equatable.dart';

/// {@template measurements_repository}
/// Repository responsible for handling user fitness entries
/// {@endtemplate}
class MeasurementsRepository {
  /// {@macro measurements_repository}
  const MeasurementsRepository(this.databaseClient);

  final DatabaseClient databaseClient;

  Future<void> saveWeight(Weight weight) async {
    await databaseClient.saveWeight(weight.value, weight.timestamp);
  }

  Stream<List<Weight>> weights({DateTime? startDate, DateTime? endDate}) {
    return databaseClient
        .weightEntries(startDate: startDate, endDate: endDate)
        .map((e) => e.map(Weight.fromDatabase).toList());
  }

  Stream<WeightProgress?> latestWeight() {
    return databaseClient.weightEntries(limit: 2, descending: true).map(
      (e) {
        if (e.isEmpty) {
          return null;
        }
        final previousValue = e.length == 2 ? e[1] : e[0];
        return WeightProgress(e.first.value, previousValue.value);
      },
    );
  }

  void deleteWeight({required int id}) {
    databaseClient.deleteWeight(id: id);
  }
}

class Weight extends Equatable {
  const Weight(
    this.value,
    this.timestamp, {
    this.id,
  });

  Weight.fromDatabase(WeightEntry weightEntry)
      : this(
          weightEntry.value,
          weightEntry.timestamp,
          id: weightEntry.id,
        );

  final double value;
  final DateTime timestamp;
  final int? id;

  @override
  List<Object?> get props => [value, timestamp, id];
}

class WeightProgress extends Equatable {
  const WeightProgress(this.value, double? previousValue)
      : offset = value - (previousValue ?? value);

  final double value;
  final double offset;

  @override
  List<Object?> get props => [value, offset];
}
