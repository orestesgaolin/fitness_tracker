part of 'steps_cubit.dart';

class StepsState extends Equatable {
  const StepsState({
    this.count = 0,
    this.permissionsGranted = false,
  });

  final int count;
  final bool permissionsGranted;

  StepsState copyWith({int? count, bool? permissionsGranted}) => StepsState(
        count: count ?? this.count,
        permissionsGranted: permissionsGranted ?? this.permissionsGranted,
      );

  @override
  List<Object> get props => [count, permissionsGranted];
}
