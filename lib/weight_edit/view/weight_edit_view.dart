import 'package:app_ui/app_ui.dart';
import 'package:fitness/l10n/l10n.dart';
import 'package:fitness/weight_edit/weight_edit.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:measurements_repository/measurements_repository.dart';

class WeightEditView extends StatelessWidget {
  const WeightEditView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WeightEditCubit>().state;
    if (state is WeightEditLoadingState) {
      return const SizedBox();
    } else if (state is WeightPopulatedState) {
      final weight = state.weight;
      final l10n = context.l10n;
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: JumboLabel('${l10n.weight}: ${weight.value} kg'),
          ),
          const Gap(16),
          Text(DateFormat('M/d/y').format(weight.timestamp)),
          const Gap(16),
          HeaderLabel(l10n.notes),
          TextFormField(
            maxLines: 3,
            initialValue: weight.note,
            onChanged: (value) {
              context.read<WeightEditCubit>().updateNote(value);
            },
          ).paddedV(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: AppButton.destructive(
                  theme: Theme.of(context),
                  onPressed: () {
                    context.read<WeightEditCubit>().delete();
                    Navigator.of(context).maybePop();
                  },
                  child: Text(l10n.delete),
                ),
              ),
              const Gap(8),
              Expanded(
                child: EditWeightButton(
                  weight: weight,
                ),
              ),
            ],
          ),
          const Gap(16),
        ],
      );
    }
    return const SizedBox();
  }
}

class EditWeightButton extends StatelessWidget {
  const EditWeightButton({
    super.key,
    required this.weight,
  });

  final Weight weight;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppButton(
      onPressed: () async {
        final cubit = context.read<WeightEditCubit>();
        final newValue = await AppBottomSheet.present<double>(
          context,
          child: WeightValueEditPage(initialWeight: weight.value),
        );
        if (newValue != null) {
          cubit.update(newValue);
        }
      },
      child: Text(l10n.edit),
    );
  }
}
