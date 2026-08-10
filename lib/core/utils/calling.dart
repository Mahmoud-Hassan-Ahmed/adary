import 'package:adary/core/errors/exceptions.dart';
import 'package:adary/core/errors/failure.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart' show Level;

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
    } catch (e) {
      // ليس كل نداء يمر عبر dio: `loadCalendart` مثلًا يستعمل حزمة http فيرمي
      // ClientException عند انقطاع الشبكة، وكان يخرج من هنا بلا التقاط فيسقط
      // التطبيق كله. وكذلك أخطاء تحويل النماذج. تُسجَّل ليبقى الخطأ مرئيًا في
      // اللوج، وتعود Left لتتولاها الشاشة.
      AppUtils.log('استثناء غير متوقّع في Calling: $e', levelLog: Level.error);
      return Left<Failure, T>(
          ServerFailure(title: 'خطأ', message: e.toString()));
    }
  }
}
