// ignore_for_file: prefer_const_constructors
import 'package:test/test.dart';
import 'package:files_repository/files_repository.dart';

void main() {
  group('FilesRepository', () {
    test('can be instantiated', () {
      expect(FilesRepository(), isNotNull);
    });
  });
}
