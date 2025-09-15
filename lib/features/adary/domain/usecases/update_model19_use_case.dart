import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/delay_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class UpdateModel19UseCase extends BaseUseCase {
  UpdateModel19UseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(Model19 entity) =>
      repo.calling(db: db.updateModel19, entity: entity);
}
