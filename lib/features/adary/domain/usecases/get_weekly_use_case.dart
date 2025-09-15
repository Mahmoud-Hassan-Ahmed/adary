import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/data/models/weekly_pan.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetWeeklyUseCase extends BaseUseCase {
  GetWeeklyUseCase({required super.repo, required super.db});
  Future<Either<Failure, PageinationModel<WeeklyPan>>> call(
          PaginationEntity entity) =>
      repo.calling(db: db.getWeeks, entity: entity);
}
