import 'package:adary/features/adary/data/models/student_model.dart';
import 'package:adary/features/adary/data/models/student_per.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StudentCardRegister extends StatefulWidget {
  final StudentInfo student;
  final int index;
  final ValueChanged<(String, String)> onChange;

  const StudentCardRegister(
      {super.key,
      required this.student,
      required this.index,
      required this.onChange});

  @override
  State<StudentCardRegister> createState() => _StudentCardRegisterState();
}

class _StudentCardRegisterState extends State<StudentCardRegister> {
  String isPresent = 's';
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          /// Avatar
          const CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage("assets/images/student.jpg"),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Name
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.student.name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    // Checkbox(
                    //   value: isChecked,
                    //   onChanged: (v) {
                    //     setState(() {
                    //       isChecked = v!;
                    //     });
                    //   },
                    // ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: noteController,
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: "تسجيل الملاحظة",
                          filled: true,
                          // fillColor: Colors.gr,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          prefixIconConstraints:
                              const BoxConstraints(maxHeight: 30, maxWidth: 30),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: SvgPicture.asset(
                              "assets/icons/pen.svg",
                              // width: 5,
                              // height: 5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// Present Button
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: isPresent,
                        onChanged: (value) {
                          setState(() {
                            isPresent = value!;
                            widget
                                .onChange((value ?? 's', noteController.text));
                          });
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 's',
                            child: Text(
                              "حاضر",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'a',
                            child: Text(
                              "غائب",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'l',
                            child: Text(
                              "متأخر",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          DropdownMenuItem(
                            value: 'p',
                            child: Text(
                              "مستأذن",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )

                    /// Note Input
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
