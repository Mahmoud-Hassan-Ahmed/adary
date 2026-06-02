import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/evidence_model.dart';
import 'package:adary/features/adary/presentation/bloc/evidence/evidence_bloc.dart';
import 'package:adary/features/adary/presentation/pages/done_added_page.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/bloc/base_bloc.dart';

class RateFile extends StatefulWidget {
  const RateFile({super.key, this.file});
  final EvidenceTeacherModel? file;

  @override
  State<RateFile> createState() => _RateFileState();
}

class _RateFileState extends State<RateFile> {
  List<int> ratings = [0, 0, 0];

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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EvidenceBloc>(),
      child: BlocBuilder<EvidenceBloc, EvidenceState>(
        builder: (context, state) {
          if (state is DoneRateFileState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppUtils.go(const DoneAddedPage(
                label: 'تم تقيم الملف',
                title: 'شكراً لتقييمك',
              ));
            });
          }
          return Scaffold(
            appBar: MyAppBar(title: 'تقييم الملف '),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(12),
              child: BtnApp(
                  label: 'حفظ ',
                  onTap: () {
                    widget.file!.rate = ratings[0];
                    BaseBloc.get<EvidenceBloc>(context)
                        .add(RateFileEvent(entity: widget.file!));
                  }),
            ),
            body: Container(
              // width: 350,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                // color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "اختر التقييم الذي تراه مناسباً",
                      style: TextStyle(color: Colors.teal),
                    ),
                    const SizedBox(height: 10),
                    buildRatingItem(0, "تقيم الملف", widget.file?.rate),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
