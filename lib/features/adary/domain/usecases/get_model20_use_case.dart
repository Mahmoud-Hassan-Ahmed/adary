import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/model_20.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetModel20UseCase extends BaseUseCase {
  GetModel20UseCase({required super.repo, required super.db});
  Future<Either<Failure, PageinationModel<Model20Model>>> call(
          PaginationEntity entity) =>
      repo.calling(db: db.getModel20, entity: entity);
}
