import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/attendance_statistics_model.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetAttendenceStatisticsUseCase extends BaseUseCase {
  GetAttendenceStatisticsUseCase({required super.repo, required super.db});
  Future<Either<Failure, AttendanceStatisticsModel>> call() =>
      repo.calling(db: db.getAttendanceStatistics, entity: null);
}
