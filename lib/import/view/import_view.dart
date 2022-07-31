import 'package:app_ui/app_ui.dart';
import 'package:files_repository/files_repository.dart';
import 'package:fitness/import/import.dart';
import 'package:fitness/l10n/l10n.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pluto_grid/pluto_grid.dart';

class ImportView extends StatelessWidget {
  const ImportView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ImportCubit>().state;
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.importData)),
      body: SafeArea(
        child: Builder(
          builder: (context) {
            if (state is InitialImportState) {
              return const ImportButton();
            } else if (state is LoadingImportState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ErrorImportState) {
              return Text(state.error.toString());
            } else if (state is FileImportedState) {
              if (state.importedFile.entries.isNotEmpty) {
                return FileView(state.importedFile);
              }
            }
            return const ImportButton();
          },
        ),
      ),
    );
  }
}

class ImportButton extends StatelessWidget {
  const ImportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppButton(
        child: Text(context.l10n.selectFile),
        onPressed: () {
          context.read<ImportCubit>().importFile();
        },
      ),
    );
  }
}

class FileView extends StatelessWidget {
  const FileView(this.importedFile, {super.key});

  final ImportedFile importedFile;

  @override
  Widget build(BuildContext context) {
    final headers = importedFile.entries.first;
    final columns = [
      for (final col in headers)
        PlutoColumn(
          title: col,
          field: col,
          type: PlutoColumnType.text(),
        ),
    ];

    final rows = [
      for (final row in importedFile.entries.skip(1))
        PlutoRow(
          cells: {
            for (var i = 0; i < headers.length; i++)
              headers[i]: PlutoCell(value: row[i]),
          },
        ),
    ];
    final l10n = context.l10n;
    return Column(
      children: [
        CheckboxListTile(
          title: Text(l10n.skipEmpty),
          value: true,
          onChanged: (_) {},
        ),
        const Divider(),
        CheckboxListTile(
          title: Text(l10n.firstRowHeader),
          value: true,
          onChanged: (_) {},
        ),
        const Divider(),
        Text(l10n.matchColumns),
        ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 4),
          child: Scrollbar(
            thumbVisibility: true,
            child: ListView(
              children: [
                for (final header in headers)
                  ListTile(
                    title: Text(header),
                  ),
              ],
            ),
          ),
        ),
        Expanded(
          child: PlutoGrid(
            columns: columns,
            rows: rows,
            mode: PlutoGridMode.selectWithOneTap,
          ),
        ),
      ],
    );
  }
}
