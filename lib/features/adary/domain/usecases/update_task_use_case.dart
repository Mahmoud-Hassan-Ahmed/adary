import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class UpdateTaskUseCase extends BaseUseCase {
  UpdateTaskUseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(BaseEnity e) =>
      repo.calling(db: db.updateTask, entity: e);
}
