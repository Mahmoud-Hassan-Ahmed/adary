import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/evidence_model.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetEvidencesCaregories extends BaseUseCase {
  GetEvidencesCaregories({required super.repo, required super.db});
  Future<Either<Failure, List<EvidenceCategoryModel>>> call() =>
      repo.calling(db: db.getEvidenceCategories, entity: null);
}
