import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/class_health.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetClassHealthsUseCase extends BaseUseCase {
  GetClassHealthsUseCase({required super.repo, required super.db});
  Future<Either<Failure, List<ClassHealth>>> call() => repo.calling(
        db: db.classsHealth,
      );
}
