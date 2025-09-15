import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/note_entity_model.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetNotesUseCase extends BaseUseCase {
  GetNotesUseCase({required super.repo, required super.db});
  Future<Either<Failure, List<NoteModel>>> call() =>
      repo.calling<List<NoteModel>>(db: db.getNotes);
}
