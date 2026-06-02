import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/exam_model.dart';
import 'package:adary/features/adary/data/models/health_model.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetExamByDayUseCase extends BaseUseCase {
  GetExamByDayUseCase({required super.repo, required super.db});
  Future<Either<Failure, PageinationModel<ExamDay>>> call(
          PaginationEntity entity) =>
      repo.calling(db: db.getExamesDays, entity: entity);
}
