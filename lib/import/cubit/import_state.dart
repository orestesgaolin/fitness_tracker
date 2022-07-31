part of 'import_cubit.dart';

abstract class ImportState extends Equatable {
  const ImportState();
}

class InitialImportState extends ImportState {
  const InitialImportState();

  @override
  List<Object?> get props => [];
}

class LoadingImportState extends ImportState {
  const LoadingImportState();

  @override
  List<Object?> get props => [];
}

class ErrorImportState extends ImportState {
  const ErrorImportState(this.error);

  final Object error;

  @override
  List<Object?> get props => [error];
}

class FileImportedState extends ImportState {
  const FileImportedState(this.importedFile);

  final ImportedFile importedFile;

  @override
  List<Object?> get props => [
        importedFile,
      ];
}
