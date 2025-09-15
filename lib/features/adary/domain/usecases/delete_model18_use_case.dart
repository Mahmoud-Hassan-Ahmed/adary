import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class DeleteModel18UseCase extends BaseUseCase {
  DeleteModel18UseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(DeleteEntity entity) =>
      repo.calling(db: db.deleteDelay, entity: entity);
}
