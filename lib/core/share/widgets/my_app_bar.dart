import 'package:adary/core/conts/style.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:adary/features/table/utils/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: non_constant_identifier_names
PreferredSizeWidget MyAppBar({String? title, List<Widget>? actions}) => AppBar(
      iconTheme: const IconThemeData(color: AppColors.SECONDERYCOLOR),
      centerTitle: true,
      title: LabelMainText(
        text: title ?? '',
        fontSize: 20,
      ),
      actions: actions,
    );
