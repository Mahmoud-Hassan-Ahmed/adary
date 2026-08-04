import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String title;

  const Failure({
    required this.message,
    required this.title,
  });
  @override
  List<Object?> get props => [message];
  @override
  String toString() {
    return '$title : $message';
  }
}

class OfflineFailure extends Failure {
  const OfflineFailure({required super.title, required super.message});
}

class FirebaseDatabaseFailure extends Failure {
  const FirebaseDatabaseFailure({required super.message, required super.title});
}

/// ردّ خطأ من الخادم (404، 500، انتهاء مهلة...). رسالته للسجل فقط — ما يراه
/// المستخدم يعرضه اعتراض dio في إشعار منبثق.
class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.title});
}
