// ignore_for_file: public_member_api_docs

import 'dart:io';

import 'package:csv/csv.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';

/// {@template files_repository}
/// Package accessing the files
/// {@endtemplate}
class FilesRepository {
  /// {@macro files_repository}
  const FilesRepository();

  Future<ImportedFile?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'csv'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final content = await file.readAsString();
      final rowsAsListOfValues = const CsvToListConverter(
        shouldParseNumbers: false,
        allowInvalid: true,
      ).convert<String>(
        content,
      );
      return ImportedFile(
        filePath: file.path,
        fileName: basename(file.path),
        entries: rowsAsListOfValues,
      );
    } else {
      return null;
    }
  }
}

class ImportedFile extends Equatable {
  const ImportedFile({
    required this.filePath,
    required this.fileName,
    required this.entries,
  });

  final String filePath;
  final String fileName;
  final List<List<String>> entries;

  @override
  List<Object?> get props => [
        filePath,
        fileName,
        entries,
      ];
}



// class WeightRowEntry extends RowEntry {
//   WeightRowEntry(this.value);

//   final double? value;

//   @override
//   List<Object?> get props => [value];
// }

// class ExerciseRowEntry extends RowEntry {
//   ExerciseRowEntry(this.note, this.title, this.type, this.duration);

//   final String? note;
//   final String? title;
//   final String? type;
//   final int duration;

//   @override
//   List<Object?> get props => [note, title, type, duration];
// }
