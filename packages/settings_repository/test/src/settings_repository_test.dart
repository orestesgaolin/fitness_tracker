// ignore_for_file: prefer_const_constructors
import 'package:database_client/database_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:test/test.dart';

class MockSettingsResource extends Mock implements SettingsResource {}

void main() {
  group('SettingsRepository', () {
    late SettingsResource settingsResource;

    setUp(() {
      settingsResource = MockSettingsResource();
    });

    test('can be instantiated', () {
      expect(SettingsRepository(settingsResource), isNotNull);
    });
  });
}
