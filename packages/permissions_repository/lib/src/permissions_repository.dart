// ignore_for_file: public_member_api_docs

import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/subjects.dart';

/// {@template permissions_repository}
/// Package accessing the permissions
/// {@endtemplate}
class PermissionsRepository {
  /// {@macro permissions_repository}
  PermissionsRepository();

  final _subject = BehaviorSubject<bool>();

  Stream<bool> hasAccessToActivity() {
    Permission.activityRecognition.isGranted.then(_subject.add);
    return _subject.stream;
  }

  Future<bool> requestActivityAccess() async {
    final value = await Permission.activityRecognition.request();
    _subject.add(value.isGranted);
    return value.isGranted;
  }
}
