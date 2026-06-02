import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/evidence_model.dart';
import 'package:adary/features/adary/data/models/note_entity_model.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class RateFileUseCase extends BaseUseCase {
  RateFileUseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(EvidenceTeacherModel entity) =>
      repo.calling(db: db.rateFile, entity: entity);
}
