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

  Stream<List<Weight>> weights() {
    return databaseClient
        .weightEntries()
        .map((e) => e.map((e) => Weight.fromDatabase(e)).toList());
  }
}

class Weight extends Equatable {
  const Weight(this.value, this.timestamp);

  Weight.fromDatabase(WeightEntry weightEntry)
      : this(
          weightEntry.value,
          weightEntry.timestamp,
        );

  final double value;
  final DateTime timestamp;

  @override
  List<Object?> get props => [value, timestamp];
}
