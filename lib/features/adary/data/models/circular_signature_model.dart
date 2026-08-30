/// توقيعات المعلمين على تعميم إداري واحد.
///
/// يقابل `GET api/notes/circulars/<id>/signatures/` في الخادم. صورة التوقيع
/// محفوظة مرة واحدة على المعلم نفسه، والمعلم يوقّع التعميم من تطبيقه فيصبح
/// `is_signed = true` مع وقت التوقيع.
class TeacherSignature {
  final int teacherId;
  final String teacherName;
  final bool isSigned;

  /// اطّلع على التعميم دون أن يوقّعه — العلم القديم `is_signature`.
  final bool isViewed;
  final String? signedAt;
  final String? signatureUrl;

  TeacherSignature({
    required this.teacherId,
    required this.teacherName,
    this.isSigned = false,
    this.isViewed = false,
    this.signedAt,
    this.signatureUrl,
  });

  factory TeacherSignature.fromJson(Map<String, dynamic> json) {
    return TeacherSignature(
      teacherId: json['teacher_id'] ?? 0,
      teacherName: json['teacher_name']?.toString() ?? '',
      isSigned: json['is_signed'] ?? false,
      isViewed: json['is_viewed'] ?? false,
      signedAt: json['signed_at']?.toString(),
      signatureUrl: json['signature_url']?.toString(),
    );
  }
}

class CircularSignatures {
  final int circularId;
  final String circularTitle;
  final int signedCount;
  final int totalCount;
  final List<TeacherSignature> teachers;

  CircularSignatures({
    required this.circularId,
    required this.circularTitle,
    required this.signedCount,
    required this.totalCount,
    required this.teachers,
  });

  factory CircularSignatures.fromJson(Map<String, dynamic> json) {
    final rows = json['teachers'];
    return CircularSignatures(
      circularId: json['circular_id'] ?? 0,
      circularTitle: json['circular_title']?.toString() ?? '',
      signedCount: json['signed_count'] ?? 0,
      totalCount: json['total_count'] ?? 0,
      teachers: rows is List
          ? rows
              .whereType<Map<String, dynamic>>()
              .map(TeacherSignature.fromJson)
              .toList()
          : <TeacherSignature>[],
    );
  }
}
