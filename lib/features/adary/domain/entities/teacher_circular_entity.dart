class TeacherCircularEntity {
  final int teacher;
  final int administrativeCirculars;
  final bool isSignature;

  TeacherCircularEntity({
    required this.teacher,
    required this.administrativeCirculars,
    required this.isSignature,
  });

  Map<String, dynamic> toJson() {
    return {
      'teacher_id': teacher,
      'administrative_circulars': administrativeCirculars,
      'is_signature': isSignature,
    };
  }
}
