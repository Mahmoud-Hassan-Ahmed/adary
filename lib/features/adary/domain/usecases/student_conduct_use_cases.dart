import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/data/models/student_conduct.dart';
import 'package:adary/features/adary/domain/entities/student_conduct_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

/// نداءات «المواظبة والسلوك» — قسم 7.

class GetStudentAttendanceRecordUseCase extends BaseUseCase {
  GetStudentAttendanceRecordUseCase({required super.repo, required super.db});

  Future<Either<Failure, StudentAttendanceRecord>> call(
          StudentRecordEntity entity) =>
      repo.calling(db: db.getStudentAttendanceRecord, entity: entity);
}

class GetStudentBehaviorRecordUseCase extends BaseUseCase {
  GetStudentBehaviorRecordUseCase({required super.repo, required super.db});

  Future<Either<Failure, StudentBehaviorRecord>> call(
          StudentRecordEntity entity) =>
      repo.calling(db: db.getStudentBehaviorRecord, entity: entity);
}

class GetStudentProceduresUseCase extends BaseUseCase {
  GetStudentProceduresUseCase({required super.repo, required super.db});

  Future<Either<Failure, PageinationModel<StudentProcedure>>> call(
          ProceduresFilterEntity entity) =>
      repo.calling(db: db.getStudentProcedures, entity: entity);
}

class AddStudentProceduresUseCase extends BaseUseCase {
  AddStudentProceduresUseCase({required super.repo, required super.db});

  Future<Either<Failure, void>> call(List<Map<String, dynamic>> payload) =>
      repo.calling(db: db.addStudentProcedures, entity: payload);
}
