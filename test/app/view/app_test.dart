import 'package:background_job_repository/background_job_repository.dart';
import 'package:files_repository/files_repository.dart';
import 'package:fitness/app/app.dart';
import 'package:fitness/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:permissions_repository/permissions_repository.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MockMeasurementsRepository extends Mock
    implements MeasurementsRepository {}

class MockSettingsRepository extends Mock implements SettingsRepository {}

class MockPermissionsRepository extends Mock implements PermissionsRepository {}

class MockBackgroundJobRepository extends Mock
    implements BackgroundJobRepository {}

class MockFilesRepository extends Mock implements FilesRepository {}

void main() {
  group('App', () {
    late MeasurementsRepository measurementsRepository;
    late SettingsRepository settingsRepository;
    late PermissionsRepository permissionsRepository;
    late BackgroundJobRepository backgroundJobRepository;
    late FilesRepository filesRepository;
    final initialSettings = Settings(themeModeIndex: 0);

    setUp(() {
      measurementsRepository = MockMeasurementsRepository();
      when(() => measurementsRepository.weights())
          .thenAnswer((_) => const Stream.empty());
      when(() => measurementsRepository.latestWeight())
          .thenAnswer((_) => const Stream.empty());
      when(() => measurementsRepository.latestSteps())
          .thenAnswer((_) => const Stream.empty());
      when(() => measurementsRepository.todaySteps())
          .thenAnswer((_) => const Stream.empty());

      settingsRepository = MockSettingsRepository();
      when(() => settingsRepository.settings())
          .thenAnswer((_) => Stream.value(initialSettings));

      permissionsRepository = MockPermissionsRepository();
      when(() => permissionsRepository.hasAccessToActivity())
          .thenAnswer((_) => Stream.value(false));
      when(() => permissionsRepository.requestActivityAccess())
          .thenAnswer((_) => Future.value(false));

      backgroundJobRepository = MockBackgroundJobRepository();
      when(() => backgroundJobRepository.schedulePedometerRegistration())
          .thenAnswer((_) async => {});

      filesRepository = MockFilesRepository();

      //See https://github.com/google/flutter.widgets/issues/12
      VisibilityDetectorController.instance.updateInterval = Duration.zero;
    });

    testWidgets('renders HomePage', (tester) async {
      await tester.pumpWidget(
        App(
          initialSettings: initialSettings,
          measurementsRepository: measurementsRepository,
          settingsRepository: settingsRepository,
          permissionsRepository: permissionsRepository,
          backgroundJobRepository: backgroundJobRepository,
          filesRepository: filesRepository,
        ),
      );
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
