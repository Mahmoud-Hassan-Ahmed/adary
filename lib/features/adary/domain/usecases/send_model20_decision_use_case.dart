import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/manager_decision_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

/// اعتماد رأي المدير على نموذج ٢٠ (مساءلة غياب) وإشعار المعلّم به.
class SendModel20DecisionUseCase extends BaseUseCase {
  SendModel20DecisionUseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(ManagerDecisionEntity entity) =>
      repo.calling(db: db.sendModel20Decision, entity: entity);
}
