import 'package:animations/animations.dart';
import 'package:app_ui/app_ui.dart';
import 'package:fitness/dashboard/dashboard.dart';
import 'package:fitness/home/home.dart';
import 'package:fitness/weight_tracking/weight_tracking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedPage = context.watch<HomeCubit>().state;
    final pages = {
      HomeSelection.home: const DashboardPage(),
      HomeSelection.activity: const WeightTrackingPage(),
      HomeSelection.alarms: const SizedBox.expand(),
      HomeSelection.settings: const SizedBox.expand(),
    };
    return Scaffold(
      body: Stack(
        children: [
          PageTransitionSwitcher(
            transitionBuilder: (
              Widget child,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return FadeThroughTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                child: child,
              );
            },
            child: pages[selectedPage],
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _BottomBar(),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    final selectedPage = context.watch<HomeCubit>().state;

    return AppBottomBar(
      selectedIndex: selectedPage.index,
      children: [
        IconButton(
          onPressed: () {
            context.read<HomeCubit>().setPage(HomeSelection.home);
          },
          icon: const Icon(Icons.home_outlined),
        ),
        IconButton(
          onPressed: () {
            context.read<HomeCubit>().setPage(HomeSelection.activity);
          },
          icon: const Icon(Icons.bar_chart),
        ),
        IconButton(
          onPressed: () {
            context.read<HomeCubit>().setPage(HomeSelection.alarms);
          },
          icon: const Icon(Icons.notifications_outlined),
        ),
        IconButton(
          onPressed: () {
            context.read<HomeCubit>().setPage(HomeSelection.settings);
          },
          icon: const Icon(Icons.settings_outlined),
        ),
      ],
    );
  }
}
