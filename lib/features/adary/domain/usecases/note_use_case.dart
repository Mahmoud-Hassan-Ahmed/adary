import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/note_entity_model.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class NoteUseCase extends BaseUseCase {
  NoteUseCase({required super.repo, required super.db});
  Future<Either<Failure, PageinationModel<NoteModel>>> call(
          PaginationEntity entity) =>
      repo.calling(db: db.notes, entity: entity);
}
