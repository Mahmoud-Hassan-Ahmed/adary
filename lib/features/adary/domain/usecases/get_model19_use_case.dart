import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/model_19.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetModel19UseCase extends BaseUseCase {
  GetModel19UseCase({required super.repo, required super.db});
  Future<Either<Failure, PageinationModel<Model19Model>>> call(
          PaginationEntity entity) =>
      repo.calling(db: db.getModel19, entity: entity);
}
