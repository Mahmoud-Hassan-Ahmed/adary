import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/behavior_statistics_model.dart';
import 'package:adary/features/adary/data/models/teacher_circular.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetBehavoirStaticUseCase extends BaseUseCase {
  GetBehavoirStaticUseCase({required super.repo, required super.db});
  Future<Either<Failure, List<BehaviorStatisticsModel>>> call() =>
      repo.calling(db: db.getBehaviorStatistics, entity: null);
}
