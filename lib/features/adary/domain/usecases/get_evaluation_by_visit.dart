import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/classes.dart';
import 'package:adary/features/adary/data/models/evaluation_model.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetEvaluationByVisit extends BaseUseCase {
  GetEvaluationByVisit({required super.repo, required super.db});
  Future<Either<Failure, EvaluationModel>> call(int v) =>
      repo.calling(db: db.getIdEvaluationVisit, entity: v);
}
