import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class DeleteModel20UseCase extends BaseUseCase {
  DeleteModel20UseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(DeleteEntity entity) =>
      repo.calling(db: db.deleteModel20, entity: entity);
}
