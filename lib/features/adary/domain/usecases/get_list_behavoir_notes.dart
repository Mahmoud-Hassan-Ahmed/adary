import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/model_19.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/data/models/student_per.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetListBehavoirNotes extends BaseUseCase {
  GetListBehavoirNotes({required super.repo, required super.db});
  Future<Either<Failure, List<BehaviorNote>>> call() => repo.calling(
        db: db.getNotesBehavoir,
      );
}
