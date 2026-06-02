import 'package:adary/features/adary/domain/entities/base_enity.dart';

class NoteBehavoirEntity extends BaseEnity {
  final String title, icon, note_type;
  final int points;

  NoteBehavoirEntity(
      {required this.title,
      required this.icon,
      required this.note_type,
      required this.points});

  @override
  Map<String, dynamic> toJson() =>
      {"title": title, "icon": icon, "note_type": note_type, "points": points};
}
