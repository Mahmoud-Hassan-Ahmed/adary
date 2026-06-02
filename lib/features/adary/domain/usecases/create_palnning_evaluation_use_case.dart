import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/evaluation_model.dart';
import 'package:adary/features/adary/domain/entities/teachers_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class CreatePlanningEvaluationUseCase extends BaseUseCase {
  CreatePlanningEvaluationUseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(Planning entity) =>
      repo.calling<void>(db: db.updateEvaluationPlanning, entity: entity);
}
