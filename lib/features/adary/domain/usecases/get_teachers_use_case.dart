import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetTeachersUseCase extends BaseUseCase {
  GetTeachersUseCase({required super.repo, required super.db});
  Future<Either<Failure, List<Teacher>>> call() =>
      repo.calling<List<Teacher>>(db: db.getTeacher);
}
