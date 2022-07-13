// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:intl/intl.dart';
import 'package:visibility_detector/visibility_detector.dart';

const _initialOffset = 24.0;

/// This widget displays a horizontal infinite calendar
///
/// When scrolled left or right a [ResetCalendarToNowButton] is shown on the
/// far right. When tapped it resets the scroll position to [_initialOffset].
///
/// Moreover, a current [MonthName] is displayed on the far right, before the
/// [ResetCalendarToNowButton].
///
/// The [selectedDate] is highlighted.
class HorizontalCalendarListView extends StatefulWidget {
  const HorizontalCalendarListView({
    super.key,
    required this.startDate,
    required this.onTap,
    required this.selectedDate,
  });

  final DateTime startDate;
  final DateTime selectedDate;
  final void Function(DateTime) onTap;

  @override
  State<HorizontalCalendarListView> createState() =>
      _HorizontalCalendarListViewState();
}

class _HorizontalCalendarListViewState
    extends State<HorizontalCalendarListView> {
  final InfiniteScrollController scrollController =
      InfiniteScrollController(initialScrollOffset: _initialOffset);

  /// The date informing the view what month name should be displayed
  late DateTime monthDate;

  @override
  void initState() {
    super.initState();
    monthDate = widget.selectedDate;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<CalendarInViewNotification>(
      onNotification: (notification) {
        if (notification.date.month != monthDate.month) {
          monthDate = notification.date;
          SchedulerBinding.instance.scheduleFrameCallback((_) {
            setState(() {});
          });
        }

        return true;
      },
      child: Stack(
        children: [
          InfiniteListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final date = widget.startDate.add(Duration(days: index - 1));
              return VisibilityDetector(
                key: ValueKey(date),
                onVisibilityChanged: (info) {
                  if (info.visibleFraction == 1) {
                    CalendarInViewNotification(date).dispatch(context);
                  }
                },
                child: ScrollCalendarTile(
                  title: '${date.day}',
                  subtitle: DateFormat.E().format(date),
                  selected: date.isAtSameMomentAs(widget.selectedDate),
                  onTap: () => widget.onTap(date),
                ),
              );
            },
          ),
          const Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: _BgGradient(),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            right: 0,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              switchInCurve: Curves.decelerate,
              switchOutCurve: Curves.decelerate,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: SizedBox(
                width: 140,
                key: ValueKey(monthDate.month),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MonthName(monthDate: monthDate),
                    ResetCalendarToNowButton(
                      scrollController: scrollController,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MonthName extends StatelessWidget {
  const MonthName({
    super.key,
    required this.monthDate,
  });

  final DateTime monthDate;

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('MMM').format(monthDate),
      style: TextStyle(
        fontSize: 32,
        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
      ),
      textAlign: TextAlign.right,
    );
  }
}

class ResetCalendarToNowButton extends StatelessWidget {
  const ResetCalendarToNowButton({
    super.key,
    required this.scrollController,
  });

  final InfiniteScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: AnimatedBuilder(
        animation: scrollController,
        builder: (context, child) {
          return AnimatedOpacity(
            opacity: scrollController.offset != _initialOffset ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: child,
          );
        },
        child: InkWell(
          onTap: () {
            scrollController.animateTo(
              _initialOffset,
              duration: const Duration(milliseconds: 300),
              curve: Curves.decelerate,
            );
          },
          child: Icon(
            Icons.restore,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
          ),
        ),
      ),
    );
  }
}

class _BgGradient extends StatelessWidget {
  const _BgGradient();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.background.withAlpha(0),
              Theme.of(context).colorScheme.background,
            ],
            stops: const [0.0, 1.0],
          ),
        ),
        child: const SizedBox(width: 130),
      ),
    );
  }
}

class ScrollCalendarTile extends StatelessWidget {
  const ScrollCalendarTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected
        ? Theme.of(context).colorScheme.onBackground
        : Colors.transparent;
    final borderColor = selected
        ? Colors.transparent
        : Theme.of(context).colorScheme.outline.withOpacity(0.25);
    final textColor = selected
        ? Theme.of(context).colorScheme.background
        : Theme.of(context).colorScheme.outline;
    final subtitleColor = selected
        ? Theme.of(context).colorScheme.background
        : Theme.of(context).colorScheme.outline.withOpacity(0.75);
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: color,
        shape: StadiumBorder(
          side: BorderSide(color: borderColor),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 28 * textScale,
                    child: Center(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: subtitleColor,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CalendarInViewNotification extends Notification {
  CalendarInViewNotification(this.date);

  final DateTime date;
}
