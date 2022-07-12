// ignore_for_file: avoid_redundant_argument_values

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
          Weight(5, DateTime(2022, 1, 29)),
        ];
        final expectedOutput = [
          Weight(1, DateTime(2022, 01, 01)), //first element
          Weight(5, DateTime(2022, 01, 04)),
          Weight(3, DateTime(2022, 01, 11)),
          Weight(1, DateTime(2022, 01, 18)),
          Weight(5, DateTime(2022, 01, 25)),
          Weight(5, DateTime(2022, 01, 29)), //last element
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
          Weight(1, DateTime(2022, 01, 15)),
          Weight(3, DateTime(2022, 01, 25)),
          Weight(3, DateTime(2022, 02, 01)),
          Weight(4, DateTime(2022, 02, 14)),
        ];

        final result = averageWeights(input);
        expect(result, equals(expectedOutput));
      });

      test('calculates averages correctly for >30 days across months', () {
        final input = [
          Weight(1, DateTime(2022, 1, 15)),
          Weight(5, DateTime(2022, 1, 25)),
          Weight(1, DateTime(2022, 1, 30)),
          Weight(5, DateTime(2022, 2, 2)),
          Weight(1, DateTime(2022, 2, 5)),
          Weight(5, DateTime(2022, 2, 14)),
          Weight(6, DateTime(2022, 2, 15)),
          Weight(4.5, DateTime(2022, 2, 16)),
          Weight(7, DateTime(2022, 3, 2)),
          Weight(6, DateTime(2022, 3, 7)),
          Weight(4, DateTime(2022, 3, 9)),
          Weight(4, DateTime(2022, 4, 1)),
          Weight(4, DateTime(2022, 5, 2)),
        ];

        final expectedOutput = [
          Weight(1, DateTime(2022, 01, 15)),
          Weight(4.3, DateTime(2022, 02, 01)),
          Weight(5 + 2 / 3, DateTime(2022, 03, 01)),
          Weight(4, DateTime(2022, 04, 01)),
          Weight(4, DateTime(2022, 05, 01)),
          Weight(4, DateTime(2022, 05, 02))
        ];

        final result = averageWeights(input);
        expect(result, equals(expectedOutput));
      });
    });
  });
}
