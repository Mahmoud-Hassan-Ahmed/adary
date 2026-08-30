import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/manager_decision_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

/// اعتماد رأي المدير على مساءلة ملاحظة، ومعه ملاحظته على إفادة المعلّم.
class SendNoteAccountabilityDecisionUseCase extends BaseUseCase {
  SendNoteAccountabilityDecisionUseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(ManagerDecisionEntity entity) =>
      repo.calling(db: db.sendNoteAccountabilityDecision, entity: entity);
}
