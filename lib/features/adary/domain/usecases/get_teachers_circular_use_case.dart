import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/data/models/teacher_circular.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetTeachersCircularUseCase extends BaseUseCase {
  GetTeachersCircularUseCase({required super.repo, required super.db});
  Future<Either<Failure, PageinationModel<TeacherCircular>>> call(
          PaginationEntity entity) =>
      repo.calling(db: db.teachersCirculars, entity: entity);
}
