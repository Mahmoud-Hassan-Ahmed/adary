import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/app_notification.dart';
import 'package:adary/features/adary/domain/entities/delete_entity.dart';
import 'package:adary/features/adary/domain/usecases/notifications_use_cases.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsState extends Equatable {
  final List<AppNotification> items;
  final int unread;
  final bool loading;
  final bool failed;

  const NotificationsState({
    this.items = const [],
    this.unread = 0,
    this.loading = false,
    this.failed = false,
  });

  NotificationsState copyWith({
    List<AppNotification>? items,
    int? unread,
    bool? loading,
    bool? failed,
  }) =>
      NotificationsState(
        items: items ?? this.items,
        unread: unread ?? this.unread,
        loading: loading ?? this.loading,
        failed: failed ?? this.failed,
      );

  @override
  List<Object?> get props => [items, unread, loading, failed];
}

/// حالة الإشعارات مشتركة بين الشارة في الرأس وشاشة القائمة.
///
/// تُبقى نسخةً واحدة على مستوى التطبيق لا نسخةً لكل شاشة: الشارة والقائمة
/// يقرآن العدّاد نفسه، وفتح القائمة يصفّره في الخادم — فلو كان لكلٍّ نسخته
/// بقيت الشارة تعرض عددًا صفّره الخادم للتوّ.
class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(const NotificationsState());

  static NotificationsCubit? _instance;
  static NotificationsCubit get instance => _instance ??= NotificationsCubit();

  /// العدّاد وحده. لا يغيّر شيئًا في الخادم، فيصحّ استدعاؤه كلما عادت الشاشة.
  Future<void> refreshCount() async {
    final result = await sl<GetNewNotificationsCountUseCase>().call();
    result.fold(
      (failure) => AppUtils.log('تعذّر جلب عدد الإشعارات: $failure'),
      (count) => emit(state.copyWith(unread: count)),
    );
  }

  /// القائمة. الخادم يعلّمها مقروءةً بمجرّد ردّه، فتُصفَّر الشارة معها.
  Future<void> load() async {
    emit(state.copyWith(loading: true, failed: false));
    final result = await sl<GetNotificationsUseCase>().call();
    result.fold(
      (failure) => emit(state.copyWith(loading: false, failed: true)),
      (items) => emit(state.copyWith(
        items: items,
        loading: false,
        // الخادم صفّرها عند القراءة، فلا يُنتظر نداءٌ آخر ليعرف ذلك.
        unread: 0,
      )),
    );
  }

  Future<void> remove(int id) async {
    final result = await sl<DeleteNotificationUseCase>().call(DeleteEntity(id: id));
    result.fold(
      (failure) => AppUtils.log('تعذّر حذف الإشعار: $failure'),
      (_) => emit(state.copyWith(
        items: state.items.where((e) => e.id != id).toList(),
      )),
    );
  }
}
