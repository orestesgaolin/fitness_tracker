// ignore_for_file: prefer_const_constructors
import 'package:permissions_repository/permissions_repository.dart';
import 'package:test/test.dart';

void main() {
  group('PermissionsRepository', () {
    test('can be instantiated', () {
      expect(PermissionsRepository(), isNotNull);
    });
  });
}
