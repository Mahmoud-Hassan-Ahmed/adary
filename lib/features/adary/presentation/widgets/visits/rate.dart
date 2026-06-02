import 'package:adary/core/bloc/base_bloc.dart' show BaseBloc;
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/features/adary/data/models/evaluation_model.dart';
import 'package:adary/features/adary/presentation/bloc/evaluations/evaluations_bloc.dart';
import 'package:flutter/material.dart';

class RatingForm extends StatefulWidget {
  const RatingForm(
      {super.key,
      this.start1,
      this.start2,
      this.start3,
      this.note,
      this.label2,
      this.label3,
      this.label4,
      this.hint,
      required this.index,
      required this.id,
      required this.label1});
  final int? start1, start2, start3;
  final String? note;
  final String? label2, label3, label4, hint, label1;
  final int index;
  final int id;

  @override
  State<RatingForm> createState() => _RatingFormState();
}

class _RatingFormState extends State<RatingForm> {
  List<int> ratings = [0, 0, 0];

  TextEditingController noteController = TextEditingController();
  Widget buildRatingItem(int index, String title, int? initialRating) {
    // تأكد إن الليست فيها index ده
    if (ratings.length <= index) {
      ratings.addAll(List.filled(index - ratings.length + 1, 0));
    }

    // سيّف القيمة مرة واحدة بس
    if (ratings[index] == 0 && initialRating != null) {
      ratings[index] = initialRating;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (starIndex) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    ratings[index] = starIndex + 1;
                  });
                },
                icon: Icon(
                  Icons.star,
                  color:
                      starIndex < ratings[index] ? Colors.orange : Colors.grey,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  oninitState() {
    super.initState();
    if (widget.note != null) {
      noteController.text = widget.note!;
    }
  }

  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          // width: 350,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            // color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
          child: SingleChildScrollView(
            child: Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "اختر التقييم الذي تراه مناسباً",
                    style: TextStyle(color: Colors.teal),
                  ),
                  const SizedBox(height: 10),
                  buildRatingItem(
                      0, widget.label1 ?? "وضوح أهداف الدرس", widget.start1),
                  buildRatingItem(
                      1, widget.label2 ?? "وضوح أهداف الدرس", widget.start2),
                  buildRatingItem(
                      2, widget.label3 ?? "وضوح أهداف الدرس", widget.start3),
                  const SizedBox(height: 10),
                  Text(widget.label4 ?? "ملاحظات",
                      style: const TextStyle(color: Colors.teal)),
                  const SizedBox(height: 5),
                  TextField(
                    controller: noteController,
                    maxLines: 3,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText:
                          widget.hint ?? "ادخل اي ملاحظات حول التخطيط والإعداد",
                      filled: true,
                      // fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  BtnApp(
                    onTap: () {
                      if (formState.currentState!.validate()) {
                        BaseBloc.get<EvaluationsBloc>(context).add(
                            widget.index == 0
                                ? UpdatePlanningEvaluationEvent(
                                    planning: Planning(
                                        id: widget.id,
                                        note: noteController.text,
                                        clarityLesson: ratings[0],
                                        lessonContentAppropriate: ratings[1],
                                        appropriateEducationalMethods:
                                            ratings[2]))
                                : widget.index == 1
                                    ? UpdateImplementationEvaluationEvent(
                                        implementation: Implementation(
                                            id: widget.id,
                                            note: noteController.text,
                                            investTime: ratings[0],
                                            clarityExplanation: ratings[1],
                                            diversityStrategies: ratings[2]))
                                    : widget.index == 2
                                        ? UpdateManagementEvaluationEvent(
                                            managment: Managment(
                                                id: widget.id,
                                                note: noteController.text,
                                                controllingStudentBehavior:
                                                    ratings[0],
                                                organizingClassroom: ratings[1],
                                                investClassTime: ratings[2]))
                                        : UpdateInteractionEvaluationEvent(
                                            interaction: Interaction(
                                                id: widget.id,
                                                note: noteController.text,
                                                studentInteraction: ratings[0],
                                                variousEvaluation: ratings[1],
                                                provideFeed: ratings[2])));
                      }
                    },
                    label: "حفظ التقييم",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
