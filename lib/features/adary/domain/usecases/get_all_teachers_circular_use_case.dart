import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/teacher_circular.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetAllTeachersCircularUseCase extends BaseUseCase {
  GetAllTeachersCircularUseCase({required super.repo, required super.db});
  Future<Either<Failure, List<TeacherCircular>>> call(
          PaginationEntity entity) =>
      repo.calling(db: db.getAllTeachers, entity: entity);
}
