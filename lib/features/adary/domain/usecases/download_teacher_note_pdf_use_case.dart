import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

class DownloadTeacherNotePdfUseCase extends BaseUseCase {
  DownloadTeacherNotePdfUseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(PaginationEntity entity) =>
      repo.calling(db: db.exportPdfTeacherNote, entity: entity);
}
