// ignore_for_file: public_member_api_docs

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:infinite_listview/infinite_listview.dart';
import 'package:intl/intl.dart';

const _initialOffset = 24.0;

class HorizontalCalendarListView extends StatefulWidget {
  const HorizontalCalendarListView({
    super.key,
    required this.startDate,
    required this.onTap,
    required this.selectedDate,
  });

  final DateTime startDate;
  final DateTime selectedDate;
  final Function(DateTime) onTap;

  @override
  State<HorizontalCalendarListView> createState() =>
      _HorizontalCalendarListViewState();
}

class _HorizontalCalendarListViewState
    extends State<HorizontalCalendarListView> {
  final InfiniteScrollController scrollController =
      InfiniteScrollController(initialScrollOffset: _initialOffset);

  void resetToNow() {
    scrollController.animateTo(
      _initialOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.decelerate,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        InfiniteListView.builder(
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final date = widget.startDate.add(Duration(days: index - 1));
            return ScrollCalendarTile(
              title: '${date.day}',
              subtitle: DateFormat.E().format(date),
              selected: date.isAtSameMomentAs(widget.selectedDate),
              onTap: () => widget.onTap(date),
            );
          },
        ),
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: AnimatedBuilder(
            animation: scrollController,
            builder: (context, child) {
              return AnimatedOpacity(
                opacity: scrollController.offset != _initialOffset ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: child,
              );
            },
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(shape: const CircleBorder()),
              onPressed: resetToNow,
              child: const Icon(Icons.restore),
            ),
          ),
        ),
      ],
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
    final color = selected ? AppColors.blackBackground : Colors.transparent;
    final borderColor = selected ? Colors.transparent : Colors.black12;
    final textColor = selected ? Colors.white : Colors.black26;
    final subtitleColor = selected ? Colors.white38 : Colors.black26;
    final textScale = MediaQuery.of(context).textScaleFactor;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Material(
        color: color,
        shape: StadiumBorder(
          side: BorderSide(color: borderColor),
        ),
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
                      fontSize: 8,
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
