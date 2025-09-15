import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/class_room.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetClassRoomUseCase extends BaseUseCase {
  GetClassRoomUseCase({required super.repo, required super.db});
  Future<Either<Failure, List<Classroom>>> call() =>
      repo.calling(db: db.getClassRooms);
}
