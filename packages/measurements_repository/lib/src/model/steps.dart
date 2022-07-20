// ignore_for_file: public_member_api_docs

import 'package:equatable/equatable.dart';

class Steps extends Equatable {
  const Steps(this.count, this.timestamp);

  final int count;
  final DateTime timestamp;

  @override
  List<Object?> get props => [count, timestamp];
}
