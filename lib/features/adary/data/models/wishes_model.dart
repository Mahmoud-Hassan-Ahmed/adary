// الرغبات — نماذج قراءة لواجهات المدير في `daily-supervision/wishes/`.
//
// الرغبة الواحدة فصلٌ ومعه المواد التي اختار المعلم تدريسها فيه — لذلك
// تقول قائمة المدير "٣ رغبات" أي ثلاثة فصول، وتحمل كل بطاقة عدد موادها.

/// صف واحد في شاشة "قائمة الرغبات": معلم وعدد رغباته.
class WishTeacherModel {
  final int id;
  final String name;
  final String? photo;
  final String specialization;

  /// عدد الفصول التي سجّل فيها رغبات — هو الرقم المعروض "٣ رغبات".
  final int wishesCount;

  /// مجموع المواد داخل تلك الفصول.
  final int coursesCount;

  WishTeacherModel({
    required this.id,
    required this.name,
    required this.photo,
    required this.specialization,
    required this.wishesCount,
    required this.coursesCount,
  });

  factory WishTeacherModel.fromJson(Map<String, dynamic> json) =>
      WishTeacherModel(
        id: _asInt(json['id']),
        name: _asString(json['name']),
        photo: json['photo'] == null ? null : _asString(json['photo']),
        specialization: _asString(json['specialization']),
        wishesCount: _asInt(json['wishes_count']),
        coursesCount: _asInt(json['courses_count']),
      );

  /// الحرف الأول من الاسم — يملأ المربّع الملوّن حين لا توجد صورة.
  String get initial {
    final trimmed = name.trim();
    return trimmed.isEmpty ? '؟' : trimmed.substring(0, 1);
  }
}

/// مادة داخل رغبة.
class WishCourseModel {
  final int id;
  final String name;

  WishCourseModel({required this.id, required this.name});

  factory WishCourseModel.fromJson(Map<String, dynamic> json) =>
      WishCourseModel(
        id: _asInt(json['id']),
        name: _asString(json['name']),
      );
}

/// رغبة واحدة = بطاقة واحدة: فصل ومواده.
class WishModel {
  final int id;
  final int classroomId;
  final String classroomName;
  final List<WishCourseModel> courses;
  final int coursesCount;
  final String note;

  WishModel({
    required this.id,
    required this.classroomId,
    required this.classroomName,
    required this.courses,
    required this.coursesCount,
    required this.note,
  });

  factory WishModel.fromJson(Map<String, dynamic> json) {
    final raw = json['courses'];
    final courses = raw is List
        ? raw
            .whereType<Map>()
            .map((e) => WishCourseModel.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <WishCourseModel>[];
    return WishModel(
      id: _asInt(json['id']),
      classroomId: _asInt(json['classroom_id']),
      classroomName: _asString(json['classroom_name']),
      courses: courses,
      // الخادم يرسل العدد، لكن طول القائمة أصدق إن اختلفا.
      coursesCount: courses.isNotEmpty
          ? courses.length
          : _asInt(json['courses_count']),
      note: _asString(json['note']),
    );
  }
}

/// استجابة شاشة "رغبات <اسم المعلم>".
class TeacherWishesResponse {
  final int teacherId;
  final String teacherName;
  final String? teacherPhoto;
  final int wishesCount;
  final List<WishModel> wishes;

  TeacherWishesResponse({
    required this.teacherId,
    required this.teacherName,
    required this.teacherPhoto,
    required this.wishesCount,
    required this.wishes,
  });

  factory TeacherWishesResponse.fromJson(Map<String, dynamic> json) {
    // الغلاف `{success, message, data}` — النموذج يقبل الغلاف أو محتواه
    // مباشرة حتى لا ينكسر لو نُوديت النقطة من مكان يفكّ الغلاف مسبقًا.
    final data = _asMap(json['data'] ?? json);
    final teacher = _asMap(data['teacher']);
    final raw = data['wishes'];
    final wishes = raw is List
        ? raw
            .whereType<Map>()
            .map((e) => WishModel.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <WishModel>[];
    return TeacherWishesResponse(
      teacherId: _asInt(teacher['id']),
      teacherName: _asString(teacher['name']),
      teacherPhoto:
          teacher['photo'] == null ? null : _asString(teacher['photo']),
      wishesCount: wishes.isNotEmpty ? wishes.length : _asInt(data['wishes_count']),
      wishes: wishes,
    );
  }
}

int _asInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String _asString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  return value.toString();
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return <String, dynamic>{};
}
