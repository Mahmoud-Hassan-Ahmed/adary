import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/student_per.dart';
import 'package:adary/features/adary/presentation/pages/behavioral_notes_list.dart';
import 'package:flutter/material.dart';

class StudentNoteCard extends StatefulWidget {
  const StudentNoteCard(
      {super.key,
      required this.studentInfo,
      required this.notes,
      required this.onchange});

  final StudentInfo studentInfo;
  final List<BehaviorNote> notes;

  final ValueChanged<(int?, String?, bool?)> onchange;

  @override
  State<StudentNoteCard> createState() => _StudentNoteCardState();
}

class _StudentNoteCardState extends State<StudentNoteCard> {
  bool isChecked = false;
  BehaviorNote? selectedNote;
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Top Row (Checkbox + Name + Avatar)
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundImage: AssetImage("assets/images/student.jpg"),
              ),
              const SizedBox(width: 10),
              Text(
                widget.studentInfo.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Checkbox(
                value: isChecked,
                onChanged: (v) {
                  setState(() {
                    isChecked = v!;
                    if (selectedNote != null) {
                      widget.onchange(
                          (selectedNote?.id, textEditingController.text, v));
                    }
                  });
                },
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Buttons Row
          Row(
            children: [
              /// Notes List Button

              /// Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<BehaviorNote>(
                  value: selectedNote,
                  hint: const Text("اختر ملاحظة"),
                  underline: const SizedBox(),
                  items: widget.notes.map((e) {
                    return DropdownMenuItem(
                      value: e,
                      child: Text(e.title ?? ''),
                    );
                  }).toList(),
                  onChanged: (v) {
                    setState(() => selectedNote = v);
                  },
                ),
              ),
              const Spacer(),

              OutlinedButton.icon(
                onPressed: () {
                  AppUtils.go(const BehavioralNotesList());
                },
                icon: const Icon(Icons.list),
                label: const Text("قائمة الملاحظات"),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  foregroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Input Field
          TextField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: "تسجيل الملاحظة إضافية",
              prefixIcon: const Icon(
                Icons.edit_square,
                color: Colors.grey,
              ),
              filled: true,
              // fillColor: Colors.grey[100],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
