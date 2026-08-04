import 'package:adary/core/errors/exceptions.dart';
import 'package:adary/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class Calling {
  Future<Either<Failure, T>> call<T>(fun, dynamic input) async {
    try {
      return Right<Failure, T>(input == null ? await fun() : await fun(input));
    } on AppException catch (e) {
      return Left<Failure, T>(
          e.map('OFFLINEEXCEPTION_MESSAGE', 'OFFLINEEXCEPTION_TITLE'));
    } on DioException catch (e) {
      // فشل الطلب يعود Left فتعرض الشاشة حالة خطأ، بدل أن يخرج الاستثناء من
      // البلوك بلا التقاط فيسقط التطبيق. الرسالة التي يراها المستخدم يعرضها
      // اعتراض dio نفسه.
      return Left<Failure, T>(
          ServerFailure(title: 'خطأ', message: e.message ?? e.toString()));
    }
  }
}
