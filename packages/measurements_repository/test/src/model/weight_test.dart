import 'package:measurements_repository/measurements_repository.dart';
import 'package:test/test.dart';

void main() {
  group('Weight', () {
    group('averageWeights()', () {
      test('calculates averages correctly for <30 days', () {
        final input = [
          Weight(1, DateTime(2022, 1, 1)),
          Weight(5, DateTime(2022, 1, 5)),
          Weight(1, DateTime(2022, 1, 10)),
          Weight(5, DateTime(2022, 1, 15)),
          Weight(1, DateTime(2022, 1, 20)),
          Weight(5, DateTime(2022, 1, 30)),
        ];
        final expectedOutput = [
          Weight(1, DateTime(2022, 1, 1)),
          Weight(3, DateTime(2022, 01, 04, 12)),
          Weight(3, DateTime(2022, 01, 11, 12)),
          Weight(3, DateTime(2022, 01, 18, 12)),
          Weight(5, DateTime(2022, 1, 30)),
        ];

        final result = averageWeights(input);
        expect(result, equals(expectedOutput));
      });

      test('calculates averages correctly for <30 days across months', () {
        final input = [
          Weight(1, DateTime(2022, 1, 15)),
          Weight(5, DateTime(2022, 1, 25)),
          Weight(1, DateTime(2022, 1, 30)),
          Weight(5, DateTime(2022, 2, 2)),
          Weight(1, DateTime(2022, 2, 5)),
          Weight(5, DateTime(2022, 2, 14)),
        ];
        final expectedOutput = [
          Weight(1, DateTime(2022, 1, 15)),
          Weight(1, DateTime(2022, 1, 18, 12)),
          Weight(5, DateTime(2022, 1, 25, 12)),
          Weight(2 + 1 / 3, DateTime(2022, 2, 1, 12)),
          Weight(1, DateTime(2022, 2, 8, 12)),
          Weight(5, DateTime(2022, 2, 14)),
        ];

        final result = averageWeights(input);
        expect(result, equals(expectedOutput));
      });
    });
  });
}
