import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/note_teacher.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetTeachersNotesUseCase extends BaseUseCase {
  GetTeachersNotesUseCase({required super.repo, required super.db});
  Future<Either<Failure, PageinationModel<NotesTeacher>>> call(
          PaginationEntity entity) =>
      repo.calling(db: db.noteTeacher, entity: entity);
}
