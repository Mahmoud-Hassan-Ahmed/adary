import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/filter_report_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class DownloadUseCase extends BaseUseCase {
  DownloadUseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(FilterReportEntity entity) =>
      repo.calling(db: db.downloadReport, entity: entity);
}
