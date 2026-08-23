import 'package:adary/features/adary/data/models/student_per.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/conduct_widgets.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/note_item.dart';
import 'package:flutter/material.dart';

/// محتوى تبويب واحد في «قائمة ملاحظات السلوك».
class ListNoteBaseOnType extends StatelessWidget {
  const ListNoteBaseOnType({super.key, required this.notes});

  final List<BehaviorNote> notes;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) {
      return const ConductEmpty(text: 'لا يوجد بيانات للعرض');
    }

    return ListView(
      padding: const EdgeInsets.all(12),
      physics: const BouncingScrollPhysics(),
      children: notes.map((note) {
        final isPositive = note.note_type == 'positive';
        return NoteCard(
          title: note.title ?? '',
          type: isPositive ? 'إيجابي' : 'سلبي',
          count: note.points,
          color: isPositive
              ? const Color(0xFF4CAF50)
              : const Color(0xFFF5B301),
          icon: isPositive
              ? Icons.sentiment_satisfied_alt
              : Icons.sentiment_dissatisfied,
          number: note.points.abs(),
        );
      }).toList(),
    );
  }
}
