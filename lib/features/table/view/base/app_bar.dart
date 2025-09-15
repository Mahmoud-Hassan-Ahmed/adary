import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../utils/dimensions.dart';
import '../../utils/style.dart';

class MainAppBar extends StatelessWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.PADDING_SIZE_DEFAULT),
          child: GestureDetector(
            onTap: () => () {
              Navigator.pop(context);
            },
            child: Row(
              children: [
                const Icon(Icons.arrow_back_ios),
                Text(
                  "back".tr(),
                  style: AlMaraiaRegular.copyWith(fontSize: 18),
                ),
              ],
            ),
          )),
    );
  }
}
