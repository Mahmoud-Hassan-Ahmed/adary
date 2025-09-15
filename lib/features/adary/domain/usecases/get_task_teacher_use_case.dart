import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/data/models/task_teacher_mdel.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetTaskTeacherUseCase extends BaseUseCase {
  GetTaskTeacherUseCase({required super.repo, required super.db});
  Future<Either<Failure, PageinationModel<DailyTaskModel>>> call(
          PaginationEntity entity) =>
      repo.calling(db: db.taskTeacher, entity: entity);
}
