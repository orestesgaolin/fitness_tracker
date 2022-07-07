import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class WeightSelectionLayout extends StatefulWidget {
  const WeightSelectionLayout({
    super.key,
    required this.initialWeight,
    required this.onChanged,
    required this.onSubmitted,
  });

  final double initialWeight;
  final void Function(double) onChanged;
  final void Function(double) onSubmitted;

  @override
  State<WeightSelectionLayout> createState() => _WeightSelectionLayoutState();
}

class _WeightSelectionLayoutState extends State<WeightSelectionLayout> {
  late double currentValue;

  @override
  void initState() {
    currentValue = widget.initialWeight;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final fractionalPart = widget.initialWeight.fractionalValue();
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 10,
        ),
        HeaderLabel(DateFormat.MMMEd().format(DateTime.now())),
        const SizedBox(
          height: 10,
        ),
        CardDecoration(
          color: AppColors.lightGrey,
          child: SizedBox(
            height: 180,
            child: Padding(
              padding: const EdgeInsets.only(left: 42, right: 42, top: 24),
              child: Row(
                children: [
                  Expanded(
                    child: NumberSelector(
                      startNumber: 2,
                      endNumber: 300,
                      initialValue: widget.initialWeight.floor(),
                      onChanged: (value) {
                        final fractionalPart = currentValue.fractionalValue();
                        widget.onChanged(value + fractionalPart / 10);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: SizedBox(
                      width: 3,
                      height: 120,
                      child: ColoredBox(
                        color: AppColors.lightGrey.darken(),
                      ),
                    ),
                  ),
                  Expanded(
                    child: NumberSelector(
                      startNumber: 0,
                      endNumber: 9,
                      initialValue: fractionalPart,
                      onChanged: (value) {
                        widget.onChanged(currentValue.floor() + value / 10);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.errorContainer,
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  child: Text(
                    MaterialLocalizations.of(context).cancelButtonLabel,
                  ),
                ),
              ),
              const Gap(8),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.secondary,
                    elevation: 0,
                  ),
                  onPressed: () {
                    widget.onSubmitted(currentValue);
                    Navigator.maybePop(context);
                  },
                  child: Text(
                    MaterialLocalizations.of(context).saveButtonLabel,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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

extension on double {
  int fractionalValue() {
    return ((this - floor()) * 10).round();
  }
}
