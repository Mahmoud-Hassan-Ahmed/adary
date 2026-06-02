class DetailsAudience {
  final DateTime dateTime;
  final String session;
  final String className;
  final int numAud;
  final int numaAbsent;
  final int numLate;
  final int permission;

  DetailsAudience(
      {required this.dateTime,
      required this.session,
      required this.className,
      required this.numAud,
      required this.numaAbsent,
      required this.numLate,
      required this.permission});
}
