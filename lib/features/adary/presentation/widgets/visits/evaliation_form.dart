import 'package:adary/features/adary/data/models/evaluation_model.dart';
import 'package:flutter/material.dart';

class EvaluationPage extends StatelessWidget {
  const EvaluationPage({super.key, required this.visit});
  final EvaluationModel visit;

  Widget buildProgressItem({
    required String title,
    required double value,
    required Color color,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              double maxWidth = constraints.maxWidth;
              double percentage = (value / 5).clamp(0, 1); // من 0 إلى 1
              double progressWidth = maxWidth * percentage;

              return Stack(
                children: [
                  Container(
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Container(
                    height: 10,
                    width: progressWidth,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 30,
          child: Text(
            value.toStringAsFixed(1),
            style: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget buildTextField(
      String title, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 5),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            // fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.teal),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.teal),
            ),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController visitEvaluationController = TextEditingController(
      text: visit.visitEvaluationNote ?? '',
    );
    TextEditingController strengthsController = TextEditingController(
      text: visit.strengths ?? '',
    );
    TextEditingController improvementsController = TextEditingController(
      text: visit.areasImprovement ?? '',
    );
    TextEditingController recommendationsController = TextEditingController(
      text: visit.recommendations ?? '',
    );
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Progress Box
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  buildProgressItem(
                    title: "الدرجة الإجمالية",
                    value: visit.overallEvaluation ?? 0,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  buildProgressItem(
                    title: "التخطيط والإعداد",
                    value: visit.planingEvaluation ?? 0,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 8),
                  buildProgressItem(
                    title: "التنفيذ والتدريس",
                    value: visit.implementationEvaluation ?? 0,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 8),
                  buildProgressItem(
                    title: "إدارة الفصل",
                    value: visit.managementEvaluation ?? 0,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 8),
                  buildProgressItem(
                    title: "التفاعل والتقييم",
                    value: visit.interactionEvaluation ?? 0,
                    color: Colors.red,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Text Fields
            buildTextField(
              "التقييم العام",
              "ادخل التقييم العام للزيارة",
              visitEvaluationController,
            ),
            buildTextField(
              "نقاط القوة",
              "ادخل نقاط القوة التي لاحظتها",
              strengthsController,
            ),
            buildTextField(
              "تحسينات التحسين",
              "اذكر المجالات التي تحتاج إلى تحسين",
              improvementsController,
            ),
            buildTextField(
              "الإقتراحات",
              "ادخل التوصيات إلى المعلم",
              recommendationsController,
            ),

            const SizedBox(height: 10),

            /// Button
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text("حفظ"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
