import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/delay_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class CreateModel18UseCase extends BaseUseCase {
  CreateModel18UseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(Model18 enity) =>
      repo.calling(db: db.crateModel18, entity: enity);
}
