import 'package:adary/core/conts/app_text_styles.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget MyAppBar({String? title, List<Widget>? actions}) => AppBar(
      iconTheme: const IconThemeData(color: AppColors.SECONDERYCOLOR),
      centerTitle: true,
      title: LabelMainText(
        text: title ?? '',
        fontSize: AppTextStyles.h3,   // 20sp — screen title
      ),
      actions: actions,
    );
