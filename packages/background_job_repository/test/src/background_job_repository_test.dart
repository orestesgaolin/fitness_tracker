// ignore_for_file: prefer_const_constructors
import 'dart:io';

import 'package:background_job_repository/background_job_repository.dart';
import 'package:test/test.dart';

void main() {
  group('BackgroundJobRepository', () {
    test('can be instantiated', () {
      expect(BackgroundJobRepository(File('no-op')), isNotNull);
    });
  });
}
