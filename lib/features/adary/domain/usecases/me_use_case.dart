import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class MeUseCase extends BaseUseCase {
  MeUseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call() => repo.calling(db: db.me);
}
