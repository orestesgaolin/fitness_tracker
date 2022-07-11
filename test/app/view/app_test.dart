import 'package:fitness/app/app.dart';
import 'package:fitness/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MockMeasurementsRepository extends Mock
    implements MeasurementsRepository {}

void main() {
  group('App', () {
    late MeasurementsRepository measurementsRepository;

    setUp(() {
      measurementsRepository = MockMeasurementsRepository();
      when(() => measurementsRepository.weights())
          .thenAnswer((_) => const Stream.empty());
      when(() => measurementsRepository.latestWeight())
          .thenAnswer((_) => const Stream.empty());

      //See https://github.com/google/flutter.widgets/issues/12
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
    });

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(
        App(
          measurementsRepository: measurementsRepository,
        ),
      );
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
