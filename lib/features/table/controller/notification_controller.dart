import 'package:adary/features/table/data/repository/notification_repository.dart';
import 'package:get/get.dart';

import '../data/api/api_checker.dart';
import '../data/model/response/notification_model.dart';

class NotificationController extends GetxController implements GetxService {
  late NotificationRepository _notificationRepository;
  NotificationController(
      {required NotificationRepository notificationRepository}) {
    _notificationRepository = notificationRepository;
  }

  int _notificationCounter = 0;
  int get notificationCounter => _notificationCounter;
  bool _isLoading = false;
  bool _isLoadingNotification = false;
  bool _isDeletingNotification = false;

  int _selectedId = 0;
  int get selectedId => _selectedId;

  bool get isLoading => _isLoading;
  bool get isLoadingNotification => _isLoadingNotification;
  bool get isDeletingNotification => _isDeletingNotification;

  List<notificationModel> _notification = [];
  List<notificationModel> get notification => _notification;

  Future<void> getNotificationCount() async {
    _isLoading = true;
    update();

    Response response = await _notificationRepository.geNotificationCount();
    if (response.statusCode == 200) {
      _notificationCounter = response.body["data"]["count"];
    } else {
      ApiChecker.checkApi(response);
    }

    _isLoading = false;
    update();
  }

  Future<void> getNotification() async {
    _isLoadingNotification = true;
    update();

    Response response = await _notificationRepository.getNotification();
    ;
    if (response.statusCode == 200) {
      _notification.clear();
      response.body["data"]["notifications"].forEach((val) {
        _notification.add(notificationModel.fromJson(val));
      });
    } else {
      ApiChecker.checkApi(response);
    }

    _isLoadingNotification = false;
    update();
  }

  Future<void> deleteNotification({required int notificationId}) async {
    _updateSelectedId(id: notificationId);
    _isDeletingNotification = true;
    update();
    Response response = await _notificationRepository.deleteNotification(
        notificationId: notificationId);

    if (response.statusCode == 200) {
      _deleteNotifiactionLoacally(id: notificationId);
      _updateSelectedId(id: 0);
    } else {
      ApiChecker.checkApi(response);
    }
    _isDeletingNotification = false;
    update();
  }

  void _deleteNotifiactionLoacally({required int id}) {
    _notification.removeWhere((element) => element.id == id);
    update();
  }

  void _updateSelectedId({required int id}) {
    _selectedId = id;
    update();
  }
}
