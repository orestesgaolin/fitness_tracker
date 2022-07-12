import 'package:fitness/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BackButtonHandler extends StatelessWidget {
  const BackButtonHandler({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (context.read<HomeCubit>().state != HomeSelection.home) {
          context.read<HomeCubit>().setPage(HomeSelection.home);
          return false;
        } else {
          return true;
        }
      },
      child: child,
    );
  }
}
