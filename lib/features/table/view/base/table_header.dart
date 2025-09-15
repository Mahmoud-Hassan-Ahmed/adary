import 'package:flutter/material.dart';

import '../../utils/dimensions.dart';
import '../../utils/style.dart';

// ignore: must_be_immutable
class TableHeader extends StatelessWidget {
  String headerTxt;
  double headerTxtSized;
  Color headerTxtColor;
  TableHeader(
      {super.key,
      required this.headerTxt,
      required this.headerTxtSized,
      required this.headerTxtColor});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.PADDING_SIZE_DEFAULT),
      child: Row(
        children: [
          Text(
            headerTxt,
            style: AlMaraiaBold.copyWith(
                fontSize: headerTxtSized, color: headerTxtColor),
          )
          //end of teacher name
        ],
      ),
    );
  }
}
