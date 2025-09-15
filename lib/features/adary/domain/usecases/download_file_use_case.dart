import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class DownloadFileUseCase extends BaseUseCase {
  DownloadFileUseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(FileDownloadEneity entity) =>
      repo.calling(db: db.doenlaodFileModel19, entity: entity);
}
