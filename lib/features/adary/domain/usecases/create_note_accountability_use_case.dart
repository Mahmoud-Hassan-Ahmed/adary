import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

/// إسناد مساءلة على ملاحظة مسجّلة على المعلّم — نظير زرّ «إرسال مساءلة» في
/// الموقع. لا يُرسل إلا معرّف الملاحظة، والخادم ينسخ نصّها وتاريخها.
class CreateNoteAccountabilityUseCase extends BaseUseCase {
  CreateNoteAccountabilityUseCase({required super.repo, required super.db});

  Future<Either<Failure, void>> call(int notesTeacherId) =>
      repo.calling(db: db.createNoteAccountability, entity: notesTeacherId);
}
