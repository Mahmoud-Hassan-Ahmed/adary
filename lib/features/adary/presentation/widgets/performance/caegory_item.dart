import 'package:adary/features/adary/data/models/evidence_model.dart';
import 'package:adary/features/adary/data/models/weekly_pan.dart';
import 'package:adary/features/adary/presentation/bloc/evidence/evidence_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/performance/add_category.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../core/bloc/base_bloc.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.model,
  });
  // final WeeklyPan weeklyPan;
  final EvidenceCategoryModel model;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      // padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF4DB6AC)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Left arrow
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xFF4DB6AC),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(11),
                bottomRight: Radius.circular(11),
              ),
            ),
            width: 50,
            height: 60,
            child: Center(
              child: Text(
                model.id.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          // Middle text
          Expanded(
            child: Text(
              model.name,
              style: const TextStyle(fontSize: 12),
            ),
          ),

          IconButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return AddCategory(
                        // pagingController: _pagingController,
                        model: model);
                  },
                );
              },
              icon: SvgPicture.asset("assets/icons/edit.svg")),
          IconButton(
              onPressed: () {
                AwesomeDialog(
                    context: context,
                    dialogType: DialogType.warning,
                    titleTextStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    title: 'تنبيه',
                    desc: 'هل أنت متأكد من حذف هذه الفئة؟',
                    btnCancelText: 'no'.tr(),
                    btnOkText: 'delete'.tr(),
                    btnCancelOnPress: () {},
                    btnOkOnPress: () {
                      BaseBloc.get<EvidenceBloc>(context).add(
                          AddCategoryEveidenceEvent(
                              entity: EvidenceCategoryModel(
                                  id: model.id ?? 0, name: '', add: 'd')));
                    }).show();
              },
              icon: SvgPicture.asset("assets/icons/delete.svg"))

          // Right selected box
        ],
      ),
    );
  }
}
