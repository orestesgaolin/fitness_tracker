import 'package:fitness/app/app.dart';
import 'package:fitness/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MockMeasurementsRepository extends Mock
    implements MeasurementsRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  group('App', () {
    late MeasurementsRepository measurementsRepository;
    late SettingsRepository settingsRepository;
    final initialSettings = Settings(themeModeIndex: 0);

    setUp(() {
      measurementsRepository = MockMeasurementsRepository();
      when(() => measurementsRepository.weights())
          .thenAnswer((_) => const Stream.empty());
      when(() => measurementsRepository.latestWeight())
          .thenAnswer((_) => const Stream.empty());

      settingsRepository = MockSettingsRepository();
      when(() => settingsRepository.settings())
          .thenAnswer((_) => Stream.value(initialSettings));

      //See https://github.com/google/flutter.widgets/issues/12
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
    });

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(
        App(
          initialSettings: initialSettings,
          measurementsRepository: measurementsRepository,
          settingsRepository: settingsRepository,
        ),
      );
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
