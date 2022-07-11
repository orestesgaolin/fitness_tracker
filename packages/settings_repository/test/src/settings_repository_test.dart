// ignore_for_file: prefer_const_constructors
import 'package:database_client/database_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings_repository/settings_repository.dart';
import 'package:test/test.dart';

class MockDatabaseClient extends Mock implements DatabaseClient {}

void main() {
  group('SettingsRepository', () {
    late DatabaseClient databaseClient;

    setUp(() {
      databaseClient = MockDatabaseClient();
    });

    test('can be instantiated', () {
      expect(SettingsRepository(databaseClient), isNotNull);
    });
  });
}
