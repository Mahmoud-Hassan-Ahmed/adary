import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:flutter/material.dart';

class NoteExit extends StatelessWidget {
  const NoteExit({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Image.asset("assets/icons/note_exit.png"),
          LabelMainText(text: 'لا يوجد بيانات للعرض')
        ],
      ),
    );
  }
}
