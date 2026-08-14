import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/data/models/wishes_model.dart';
import 'package:adary/features/adary/domain/entities/wishes_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetWishTeachersUseCase extends BaseUseCase {
  GetWishTeachersUseCase({required super.repo, required super.db});

  Future<Either<Failure, PageinationModel<WishTeacherModel>>> call(
          WishTeachersEntity entity) =>
      repo.calling(db: db.getWishTeachers, entity: entity);
}
