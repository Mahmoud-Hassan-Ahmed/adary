import 'package:dio/dio.dart';

abstract class BaseEnity {
  Map<String, dynamic> toJson();
  Future<FormData> getform() async {
    return FormData();
  }
}
