// ignore_for_file: prefer_const_constructors
import 'package:database_client/database_client.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDatabaseClient extends Mock implements DatabaseClient {}

void main() {
  group('MeasurementsRepository', () {
    late DatabaseClient databaseClient;

    setUp(() {
      databaseClient = MockDatabaseClient();
      when(() => databaseClient.weightEntries())
          .thenAnswer((_) => Stream<List<WeightEntry>>.empty());
      when(() => databaseClient.saveWeight(any(), any()))
          .thenAnswer((_) => Future.value(1));
    });

    test('can be instantiated', () {
      expect(MeasurementsRepository(databaseClient), isNotNull);
    });
  });
}
