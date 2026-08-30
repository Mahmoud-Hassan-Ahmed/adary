import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/note_accountability_model.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

/// قائمة مساءلات الملاحظات المرسلة لمعلّمي المدرسة.
class GetNoteAccountabilitiesUseCase extends BaseUseCase {
  GetNoteAccountabilitiesUseCase({required super.repo, required super.db});
  Future<Either<Failure, PageinationModel<NoteAccountabilityModel>>> call(
          PaginationEntity entity) =>
      repo.calling(db: db.getNoteAccountabilities, entity: entity);
}
