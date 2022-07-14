// ignore_for_file: prefer_const_constructors
import 'package:database_client/database_client.dart';
import 'package:measurements_repository/measurements_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockWeightResource extends Mock implements WeightResource {}

void main() {
  group('MeasurementsRepository', () {
    late WeightResource weightResource;

    setUp(() {
      weightResource = MockWeightResource();
      when(() => weightResource.weightEntries())
          .thenAnswer((_) => Stream<List<WeightEntry>>.empty());
      when(() => weightResource.saveWeight(any(), any()))
          .thenAnswer((_) => Future.value(1));
    });

    test('can be instantiated', () {
      expect(MeasurementsRepository(weightResource), isNotNull);
    });
  });
}
