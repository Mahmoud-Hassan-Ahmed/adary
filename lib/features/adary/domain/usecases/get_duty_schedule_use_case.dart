import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/duty_model.dart';
import 'package:adary/features/adary/domain/entities/duty_filter_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetDutyScheduleUseCase extends BaseUseCase {
  GetDutyScheduleUseCase({required super.repo, required super.db});

  Future<Either<Failure, DutyScheduleResponse>> call(DutyFilterEntity entity) =>
      repo.calling(db: db.getDutySchedule, entity: entity);
}
