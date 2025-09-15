import 'dart:io';

import 'package:adary/core/model/select_model.dart';
import 'package:adary/features/adary/domain/entities/base_enity.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

class CircularEntity extends BaseEnity {
  final int? id;
  String title;
  DateTime date;
  String dateHijri;
  String issuer;
  bool sendNotif;
  bool selectAll;
  final File? file;
  final List<SelectModel> teachers;

  // Constructor
  CircularEntity(
      {required this.title,
      required this.date,
      required this.dateHijri,
      this.id,
      required this.issuer,
      required this.sendNotif,
      required this.selectAll,
      required this.teachers,
      required this.file});

  @override
  Future<FormData> getform() async {
    return FormData.fromMap({
      'title': title,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'date_hijri': dateHijri,
      'issuer': issuer,
      if (file != null) 'file': await MultipartFile.fromFile(file!.path),
      'send_notif': sendNotif,
      'select_all': selectAll,
    });
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'date_hijri': dateHijri,
      'issuer': issuer,
      'send_notif': sendNotif,
      'select_all': selectAll,
    };
  }
}
