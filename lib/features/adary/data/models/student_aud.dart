import 'package:flutter/material.dart';

class StudentAud {
  final String studentName;
  final String note;
  final String status;
  final String statusName;
  final Color color;

  StudentAud(
      {required this.studentName,
      required this.note,
      required this.status,
      required this.color,
      required this.statusName});
}
