import 'package:flutter/widgets.dart';

import '../../utils/app_colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/style.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Dimensions.PADDING_SIZE_DEFAULT),
        child: Row(
          children: [
            Text(
              "الحصة الان: ",
              style:
                  AlMaraiaBold.copyWith(fontSize: 19, color: Color(0xFF9ED3D7)),
            ),
            Text(
              " الأولى",
              style: AlMaraiaBold.copyWith(
                  fontSize: 18, color: AppColors.SECONDERYCOLOR),
            ),
          ],
        ));
  }
}
