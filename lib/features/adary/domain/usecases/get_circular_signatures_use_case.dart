import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/circular_signature_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetCircularSignaturesUseCase extends BaseUseCase {
  GetCircularSignaturesUseCase({required super.repo, required super.db});
  Future<Either<Failure, CircularSignatures>> call(PaginationEntity entity) =>
      repo.calling(db: db.circularSignatures, entity: entity);
}
