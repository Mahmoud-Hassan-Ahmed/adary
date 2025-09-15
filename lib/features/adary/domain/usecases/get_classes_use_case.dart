import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/classes.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetClassesUseCase extends BaseUseCase {
  GetClassesUseCase({required super.repo, required super.db});
  Future<Either<Failure, List<Classes>>> call() =>
      repo.calling(db: db.getClasses);
}
