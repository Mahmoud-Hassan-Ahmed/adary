import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/data/models/requests_model.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class GetRequestsUseCase extends BaseUseCase {
  GetRequestsUseCase({required super.repo, required super.db});
  Future<Either<Failure, PageinationModel<LeaveRequestModel>>> call(
          BaseEnity status) =>
      repo.calling(db: db.getRequests, entity: status);
}
