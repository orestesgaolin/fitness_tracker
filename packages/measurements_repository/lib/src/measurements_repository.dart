// ignore_for_file: public_member_api_docs

import 'package:database_client/database_client.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:steps_client/steps_client.dart';

/// {@template measurements_repository}
/// Repository responsible for handling user fitness entries
/// {@endtemplate}
class MeasurementsRepository {
  /// {@macro measurements_repository}
  MeasurementsRepository(
    this.weightResource,
    this.stepsResource, [
    StepsClient? stepsClient,
  ]) : stepsClient = stepsClient ?? StepsClient();

  final WeightResource weightResource;
  final StepsResource stepsResource;
  final StepsClient stepsClient;

  Stream<Steps> latestSteps() {
    return stepsClient.latestStepCount().map((s) {
      return Steps(s.steps, s.timeStamp);
    });
  }

  /// Returns the number of steps registered for a given day
  ///
  /// It iterates through the entries and adds up the differences between
  /// them.
  ///
  /// When the phone gets rebooted, the count is reset to 0, so it
  /// only adds "positive" differences e.g. if entries are:
  ///
  /// - 1000
  /// - 1100
  /// - 1200
  /// - 0
  /// - 100
  /// - 200
  ///
  /// then the sum of steps should be 100+100+100+100+100
  Stream<Steps> todaySteps([DateTime? timestamp]) {
    final today = timestamp ?? DateTime.now();
    return stepsResource.valuesForTheDay(timestamp: today).map(
      (list) {
        if (list.isEmpty) {
          return Steps(0, today);
        }
        if (list.length == 1) {
          return Steps(0, today);
        }

        var sum = 0;
        for (var i = 1; i < list.length; i++) {
          final previousValue = i > 0 ? list[i - 1].value : 0;

          final difference = list[i].value - previousValue;
          if (difference > 0) {
            sum += difference;
          }
        }

        return Steps(sum, today);
      },
    );
  }

  Future<void> saveSteps(Steps steps) {
    return stepsResource.saveSteps(
      steps.count,
      steps.timestamp,
    );
  }

  Stream<List<Weight>> weights({DateTime? startDate, DateTime? endDate}) {
    return weightResource
        .weightEntries(startDate: startDate, endDate: endDate)
        .map((e) => e.map(Weight.fromDatabase).toList());
  }

  Stream<WeightProgress?> latestWeight() {
    return weightResource.weightEntries(limit: 2, descending: true).map(
      (e) {
        if (e.isEmpty) {
          return null;
        }
        final previousValue = e.length == 2 ? e[1] : e[0];
        return WeightProgress(e.first.value, previousValue.value);
      },
    );
  }

  Future<void> saveWeight(Weight weight) async {
    await weightResource.saveWeight(weight.value, weight.timestamp);
  }

  void deleteWeight({required int id}) {
    weightResource.deleteWeight(id: id);
  }

  Stream<Weight> getWeight(int id) {
    return weightResource.weightEntry(id: id).map(Weight.fromDatabase);
  }

  Future<void> updateWeight({required Weight weight}) async {
    await weightResource.updateWeight(
      WeightEntry(
        id: weight.id!,
        value: weight.value,
        timestamp: weight.timestamp,
        created: weight.created ?? DateTime.now(),
        note: weight.note,
      ),
    );
  }
}
