// مدخلات نداءات «المواظبة والسلوك» — نداء واحد يمرّر كائنًا واحدًا كما يتوقّع
// `Calling`.

/// «الفترة» المنسدلة في شاشات السجل.
class ConductPeriod {
  static const today = 'today';
  static const thisWeek = 'this_week';
  static const thisMonth = 'this_month';
  static const thisTerm = 'this_term';
  static const all = 'all';

  /// بالترتيب الذي تعرضه القائمة، ونصوصها كما في التصميم.
  static const List<MapEntry<String, String>> options = [
    MapEntry(today, 'اليوم'),
    MapEntry(thisWeek, 'هذا الأسبوع'),
    MapEntry(thisMonth, 'هذا الشهر'),
    MapEntry(thisTerm, 'هذا الفصل'),
    MapEntry(all, 'الكل'),
  ];

  static String label(String value) => options
      .firstWhere((e) => e.key == value,
          orElse: () => const MapEntry(thisMonth, 'هذا الشهر'))
      .value;
}

/// سجل حضور الطالب أو سجل سلوكه.
class StudentRecordEntity {
  final int studentId;
  final String period;

  StudentRecordEntity({
    required this.studentId,
    this.period = ConductPeriod.thisMonth,
  });
}

/// قائمة «الإجراءات المتخذة» — تُقيَّد بالطالب وبمصدر الإجراء.
class ProceduresFilterEntity {
  final int? studentId;
  final String? source;
  final String period;

  ProceduresFilterEntity({
    this.studentId,
    this.source,
    this.period = ConductPeriod.thisMonth,
  });
}
