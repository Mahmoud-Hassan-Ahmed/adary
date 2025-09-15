import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/delay_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class UpdatModel18UseCase extends BaseUseCase {
  UpdatModel18UseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(Model18 entity) =>
      repo.calling(db: db.updateDelay, entity: entity);
}
