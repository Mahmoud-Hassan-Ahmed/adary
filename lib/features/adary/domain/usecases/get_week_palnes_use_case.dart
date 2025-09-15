import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/data/models/week_plan.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetWeekPalnesUseCase extends BaseUseCase {
  GetWeekPalnesUseCase({required super.repo, required super.db});
  Future<Either<Failure, PageinationModel<Plan>>> call(
          PaginationEntity entity) =>
      repo.calling(db: db.getWeekPan, entity: entity);
}
