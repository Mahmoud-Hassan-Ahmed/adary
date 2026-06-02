import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DoneAddedPage extends StatelessWidget {
  const DoneAddedPage({super.key, required this.label, required this.title});
  final String label;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: title),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset("assets/icons/icon-added.svg"),
            const SizedBox(
              height: 10,
            ),
            LabelMainText(
              text: label,
              fontSize: 25,
            )
          ],
        ),
      ),
    );
  }
}
