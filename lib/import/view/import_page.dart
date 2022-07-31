import 'package:files_repository/files_repository.dart';
import 'package:fitness/import/import.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ImportPage extends StatelessWidget {
  const ImportPage({super.key});

  static Route<void> get route => MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (context) => ImportCubit(context.read<FilesRepository>()),
          child: const ImportPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return const ImportView();
  }
}
