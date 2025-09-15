import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class CreateModel19UseCase extends BaseUseCase {
  CreateModel19UseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(BaseEnity entity) =>
      repo.calling(db: db.crateModel19, entity: entity);
}
