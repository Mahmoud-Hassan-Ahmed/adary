import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/weekly_pan.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_weekly_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/week_plan/week_plan_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/visits/plans.dart';
import 'package:adary/features/adary/presentation/widgets/week_plans/week_item.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class WeekPlaning extends StatefulWidget {
  WeekPlaning({
    super.key,
    required this.pagingController,
    required this.entity,
  });
  final PagingController<int, WeeklyPan> pagingController;
  PaginationEntity entity;

  @override
  State<WeekPlaning> createState() => _WeekPlaningState();
}

class _WeekPlaningState extends State<WeekPlaning> {
  final getModel20useCase = sl<GetWeeklyUseCase>();
  @override
  void initState() {
    widget.entity = PaginationEntity(page: 1);
    widget.pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    var result = await getModel20useCase(widget.entity..page = pageKey);
    try {
      result.fold((l) => null, (paginationModel) {
        final isLastPage = paginationModel.next == null;
        if (isLastPage) {
          widget.pagingController.appendLastPage(paginationModel.results);
        } else {
          widget.pagingController
              .appendPage(paginationModel.results, pageKey + 1);
        }
      });
    } catch (error) {
      widget.pagingController.error = error;
      AppUtils.log(error.toString());
    }
  }

  int selectPage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WeekPlanBloc>(),
      child: BlocBuilder<WeekPlanBloc, WeekPlanState>(
        builder: (context, state) {
          if (state is DoneDeletePlanState) {
            AppUtils.showCustomSnackbar('deleted_plan'.tr(), SnackType.SUCESS);
            widget.pagingController.refresh();
          }
          return SafeArea(
            child: Scaffold(
              // appBar: MyAppBar(title: 'week_palns'.tr()),
              body: PagedListView<int, WeeklyPan>(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  pagingController: widget.pagingController,
                  builderDelegate: PagedChildBuilderDelegate<WeeklyPan>(
                      noItemsFoundIndicatorBuilder: (context) => Center(
                            child: Image.asset('assets/images/add.png'),
                          ),
                      itemBuilder: (context, item, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Plans(
                                      weekId: item,
                                    )));
                          },
                          child: WeekItem(
                            weeklyPan: item,
                          ),
                        );
                        // return ListTile(
                        //   onTap: () {
                        //     Navigator.of(context).push(MaterialPageRoute(
                        //         builder: (context) => Plans(
                        //               weekId: item,
                        //             )));
                        //   },
                        //   leading: Image.asset(AppIcon.pdf),
                        //   title: Text(
                        //     item.weekNumberText,
                        //     style: Theme.of(context).textTheme.labelMedium,
                        //   ),
                        //   subtitle: Text(
                        //     "${"num_plans".tr()} ${item.weeklyPlansCount}",
                        //     // textAlign: TextAlign.end,
                        //     style: Theme.of(context).textTheme.labelMedium,
                        //   ),
                        // );
                      })),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    // widget.pagingController.dispose();
    super.dispose();
  }
}
