import 'package:adary/core/errors/failure.dart';
import 'package:adary/features/adary/data/models/app_notification.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/usecases/base_use_case.dart';
import 'package:dartz/dartz.dart';

/// قائمة الإشعارات. الخادم يعلّمها مقروءةً بمجرّد ردّه، فلا تُنادى إلا حين
/// يفتح المستخدم الشاشة فعلًا — ونداؤها لتحديث الشارة يصفّرها.
class GetNotificationsUseCase extends BaseUseCase {
  GetNotificationsUseCase({required super.repo, required super.db});
  Future<Either<Failure, List<AppNotification>>> call() =>
      repo.calling(db: db.notifications);
}

/// عدد غير المقروء — لا يغيّر حالة شيء، فيصحّ استدعاؤه دوريًا.
class GetNewNotificationsCountUseCase extends BaseUseCase {
  GetNewNotificationsCountUseCase({required super.repo, required super.db});
  Future<Either<Failure, int>> call() => repo.calling(db: db.newNotificationsCount);
}

class DeleteNotificationUseCase extends BaseUseCase {
  DeleteNotificationUseCase({required super.repo, required super.db});
  Future<Either<Failure, void>> call(DeleteEntity entity) =>
      repo.calling(db: db.deleteNotification, entity: entity);
}
