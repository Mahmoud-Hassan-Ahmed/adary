import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/model18.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetModels18UseCase extends BaseUseCase {
  GetModels18UseCase({required super.repo, required super.db});
  Future<Either<Failure, PageinationModel<Model18Model>>> call(
          PaginationEntity entity) =>
      repo.calling(db: db.getModel18, entity: entity);
}
