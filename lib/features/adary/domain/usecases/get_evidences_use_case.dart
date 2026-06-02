import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/evidence_model.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/domain/entities/evidence_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetEvidencesUseCase extends BaseUseCase {
  GetEvidencesUseCase({required super.repo, required super.db});
  Future<Either<Failure, PageinationModel<EvidenceTeacherModel>>> call(
          EvidencePaginationEntity entity) =>
      repo.calling(db: db.getEvidences, entity: entity);
}
