import 'package:flutter/material.dart';

class NumberSelector extends StatefulWidget {
  const NumberSelector({
    super.key,
    required this.startNumber,
    required this.endNumber,
    required this.initialValue,
    required this.onChanged,
  });

  final int startNumber;
  final int endNumber;
  final int initialValue;
  final void Function(int) onChanged;

  @override
  State<NumberSelector> createState() => _NumberSelectorState();
}

class _NumberSelectorState extends State<NumberSelector> {
  late final FixedExtentScrollController scrollController;
  int selectedIndex = 0;
  final itemExtent = 60.0;

  @override
  void initState() {
    super.initState();
    scrollController = FixedExtentScrollController(
      initialItem: widget.initialValue - widget.startNumber,
    );
    selectedIndex = widget.initialValue;
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListWheelScrollView.useDelegate(
      controller: scrollController,
      physics: const FixedExtentScrollPhysics(),
      childDelegate: ListWheelChildLoopingListDelegate(
        children: [
          for (var i = widget.startNumber; i <= widget.endNumber; i++)
            Text(
              '$i',
              style: TextStyle(
                fontWeight:
                    selectedIndex == i ? FontWeight.bold : FontWeight.normal,
                fontSize: 24,
              ),
            ),
        ],
      ),
      itemExtent: itemExtent,
      onSelectedItemChanged: (index) {
        setState(() {
          selectedIndex = index + widget.startNumber;
        });
        widget.onChanged(selectedIndex);
      },
    );
  }
}
