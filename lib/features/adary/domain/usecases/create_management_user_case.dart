import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/evaluation_model.dart';
import 'package:adary/features/adary/domain/entities/teachers_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class CreateManagementEvaluationUseCase extends BaseUseCase {
  CreateManagementEvaluationUseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(Managment entity) =>
      repo.calling<void>(db: db.updateEvaluationManagment, entity: entity);
}
