import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/features/adary/data/models/weekly_pan.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/presentation/pages/settings_week.dart';
import 'package:adary/features/adary/presentation/pages/week_planing.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:adary/features/adary/presentation/widgets/visits/filter_week.dart';
import 'package:adary/features/adary/presentation/widgets/week_plans/add_week.dart';
import 'package:easy_localization/easy_localization.dart'
    show StringTranslateExtension;
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/share/widgets/my_app_bar.dart';

class WeeksPage extends StatefulWidget {
  const WeeksPage({super.key});

  @override
  State<WeeksPage> createState() => _WeeksPageState();
}

class _WeeksPageState extends State<WeeksPage> {
  int selectPage = 0;
  final PagingController<int, WeeklyPan> _pagingController =
      PagingController(firstPageKey: 1);
  PaginationEntity entity = PaginationEntity(page: 1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'الخطط الأسبوعية'.tr(), actions: [
        IconButton(
          onPressed: () {
            if (selectPage == 0) {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return FilterWeek(
                    paginationEntity: entity!,
                    pagingController: _pagingController,
                  );
                },
              );
            } else {
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return AddWeek();
                },
              );
            }
          },
          icon: selectPage == 0
              ? SvgPicture.asset("assets/icons/icon-filter.svg")
              : SvgPicture.asset("assets/icons/icon-add.svg"),
        )
      ]),
      bottomNavigationBar: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: AppColors.APP_COLOR, width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectPage = 0;
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/icons app2-03 1.svg",
                          color: selectPage == 0
                              ? AppColors.APP_COLOR
                              : Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        LabelMainText(
                          text: 'الخطط الاسبوعية',
                          fontSize: 14,
                          color: selectPage == 0
                              ? AppColors.APP_COLOR
                              : Colors.black,
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectPage = 1;
                      });
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          "assets/icons/calender.svg",
                          color: selectPage == 1
                              ? AppColors.APP_COLOR
                              : Colors.black,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        LabelMainText(
                          text: 'إعداد الاسابيع',
                          fontSize: 14,
                          color: selectPage == 1
                              ? AppColors.APP_COLOR
                              : Colors.black,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          IconButton(
              onPressed: () {},
              icon: SvgPicture.asset("assets/icons/icon-search.svg")),
        ],
      ),
      body: selectPage == 0
          ? WeekPlaning(
              entity: entity!,
              pagingController: _pagingController,
            )
          : const SettingsWeek(),
    );
  }
}
