import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:files_repository/files_repository.dart';

part 'import_state.dart';

class ImportCubit extends Cubit<ImportState> {
  ImportCubit(this.filesRepository) : super(const InitialImportState());

  final FilesRepository filesRepository;

  Future<void> importFile() async {
    try {
      emit(const LoadingImportState());
      final file = await filesRepository.pickFile();
      if (file != null) {
        emit(FileImportedState(file));
      } else {
        emit(const InitialImportState());
      }
    } catch (e) {
      emit(ErrorImportState(e));
      addError(e);
    }
  }
}
