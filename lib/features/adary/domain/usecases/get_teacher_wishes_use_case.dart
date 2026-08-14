import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/wishes_model.dart';
import 'package:adary/features/adary/domain/entities/wishes_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetTeacherWishesUseCase extends BaseUseCase {
  GetTeacherWishesUseCase({required super.repo, required super.db});

  Future<Either<Failure, TeacherWishesResponse>> call(
          TeacherWishesEntity entity) =>
      repo.calling(db: db.getTeacherWishes, entity: entity);
}
