import 'package:adary/features/adary/data/models/student_per.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/note_item.dart';
import 'package:flutter/material.dart';

class ListNoteBaseOnType extends StatelessWidget {
  const ListNoteBaseOnType({super.key, required this.notes});
  final List<BehaviorNote> notes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
          padding: const EdgeInsets.all(12),
          children: notes
              .map((e) => NoteCard(
                    title: e.title ?? '',
                    type: e.note_type == 'positive' ? "ايجابي" : "سلبي",
                    count: e.points,
                    color: e.note_type == 'positive'
                        ? Colors.lightGreen
                        : Colors.deepOrange,
                    icon: Icons.sentiment_satisfied_alt,
                    number: e.id,
                  ))
              .toList()),
    );
  }
}
