import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/delay_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class UpdatModel20UseCase extends BaseUseCase {
  UpdatModel20UseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(Model20 entity) =>
      repo.calling(db: db.updateModel20, entity: entity);
}
