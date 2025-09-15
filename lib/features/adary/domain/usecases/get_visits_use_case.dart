import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/data/models/visits_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetVisitsUseCase extends BaseUseCase {
  GetVisitsUseCase({required super.repo, required super.db});
  Future<Either<Failure, PageinationModel<VisitModel>>> call(
          PaginationEntity entity) =>
      repo.calling(db: db.getVisits, entity: entity);
}
