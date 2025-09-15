import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/task_model.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetTasksUseCase extends BaseUseCase {
  GetTasksUseCase({required super.repo, required super.db});
  Future<Either<Failure, List<TaskModel>>> call() =>
      repo.calling(db: db.getTadks);
}
