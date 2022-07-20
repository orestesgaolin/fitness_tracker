// ignore_for_file: public_member_api_docs

import 'package:pedometer/pedometer.dart';
import 'package:rxdart/subjects.dart';

/// {@template steps_client}
/// Package accessing the steps
/// {@endtemplate}
class StepsClient {
  /// {@macro steps_client}
  StepsClient() {
    Pedometer.stepCountStream.listen(_subject.add);
    Pedometer.pedestrianStatusStream.listen((event) async {
      if (event.status == 'walking') {
        final steps = await Pedometer.stepCountStream.first;
        _subject.add(steps);
      }
    });
  }

  final _subject = BehaviorSubject<StepCount>();

  Stream<StepCount> latestStepCount() => _subject.stream;
}
