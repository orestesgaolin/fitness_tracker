import 'package:bloc_test/bloc_test.dart';
import 'package:fitness/dashboard/cubit/dashboard_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DashboardCubitTest', () {
    blocTest<DashboardCubit, DashboardState>(
      'emits new selected date when selectDate called',
      build: DashboardCubit.new,
      act: (cubit) => cubit.selectDate(DateTime(2020)),
      expect: () => [
        DashboardState(selectedDate: DateTime(2020)),
      ],
    );
  });
}
