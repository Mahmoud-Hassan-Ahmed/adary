import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/teachers_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class CreateNoteTeachersUseCase extends BaseUseCase {
  CreateNoteTeachersUseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(TeachersEntity entity) =>
      repo.calling<void>(db: db.createNotTeacher, entity: entity);
}
