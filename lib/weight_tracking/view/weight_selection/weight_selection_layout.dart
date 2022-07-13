import 'package:app_ui/app_ui.dart';
import 'package:fitness/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef OnWeightSelected = void Function(double, DateTime);

class WeightSelectionLayout extends StatefulWidget {
  const WeightSelectionLayout({
    super.key,
    required this.initialWeight,
    required this.onChanged,
    required this.onSubmitted,
  });

  final double initialWeight;
  final OnWeightSelected onChanged;
  final OnWeightSelected onSubmitted;

  @override
  State<WeightSelectionLayout> createState() => _WeightSelectionLayoutState();
}

class _WeightSelectionLayoutState extends State<WeightSelectionLayout> {
  late double currentValue;
  late DateTime dateTime;

  @override
  void initState() {
    final now = DateTime.now();
    dateTime = DateTime(now.year, now.month, now.day);
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
        CardDecoration(
          color: Theme.of(context).colorScheme.surface,
          child: InkWell(
            onTap: () async {
              final selected = await showDatePicker(
                context: context,
                initialDate: dateTime,
                firstDate: DateTime(2000),
                lastDate: DateTime.now().add(const Duration(days: 1000)),
              );
              if (selected != null) {
                setState(() {
                  dateTime = selected;
                });
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: HeaderLabel(
                DateFormat.MMMEd().format(dateTime),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        CardDecoration(
          color: Theme.of(context).colorScheme.surface,
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
                        currentValue = value + fractionalPart / 10;
                        widget.onChanged(currentValue, dateTime);
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
                        currentValue = currentValue.floor() + value / 10;
                        widget.onChanged(currentValue, dateTime);
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
                child: AppButton.destructive(
                  theme: Theme.of(context),
                  onPressed: () {
                    Navigator.maybePop(context);
                  },
                  child: Text(context.l10n.cancel),
                ),
              ),
              const Gap(8),
              Expanded(
                child: AppButton(
                  onPressed: () {
                    widget.onSubmitted(currentValue, dateTime);
                  },
                  child: Text(context.l10n.save),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

extension on double {
  int fractionalValue() {
    return ((this - floor()) * 10).round();
  }
}
