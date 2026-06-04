import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/change_status_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class ChangeStatusUseCase extends BaseUseCase {
  ChangeStatusUseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(ChangeStatusEntity entity) =>
      repo.calling(db: db.chanageStatus, entity: entity);
}
