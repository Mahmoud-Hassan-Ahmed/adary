import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/data/models/student_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetStudentsUseCase extends BaseUseCase {
  GetStudentsUseCase({required super.repo, required super.db});
  Future<Either<Failure, PageinationModel<StudentModel>>> call(
          PaginationEntity entity) =>
      repo.calling(db: db.getStudents, entity: entity);
}
