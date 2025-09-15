import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/week_plan.dart';
import 'package:adary/features/adary/data/models/weekly_pan.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_week_palnes_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_weekly_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_weekly_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/week_plan/week_plan_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/visits/filter_week.dart';
import 'package:adary/features/adary/presentation/widgets/visits/plans.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class WeekPlaning extends StatefulWidget {
  const WeekPlaning({
    super.key,
  });

  @override
  State<WeekPlaning> createState() => _WeekPlaningState();
}

class _WeekPlaningState extends State<WeekPlaning> {
  final PagingController<int, WeeklyPan> _pagingController =
      PagingController(firstPageKey: 1);
  late PaginationEntity entity;

  final getModel20useCase = sl<GetWeeklyUseCase>();
  @override
  void initState() {
    entity = PaginationEntity(page: 1);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    var result = await getModel20useCase(entity..page = pageKey);
    try {
      result.fold((l) => null, (paginationModel) {
        final isLastPage = paginationModel.next == null;
        if (isLastPage) {
          _pagingController.appendLastPage(paginationModel.results);
        } else {
          _pagingController.appendPage(paginationModel.results, pageKey + 1);
        }
      });
    } catch (error) {
      _pagingController.error = error;
      AppUtils.log(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<WeekPlanBloc>(),
      child: BlocBuilder<WeekPlanBloc, WeekPlanState>(
        builder: (context, state) {
          if (state is DoneDeletePlanState) {
            AppUtils.showCustomSnackbar('deleted_plan'.tr(), SnackType.SUCESS);
            _pagingController.refresh();
          }
          return SafeArea(
            child: Scaffold(
              appBar: MyAppBar(title: 'week_palns'.tr()),
              bottomNavigationBar: BottomNavigatorBar(items: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return FilterWeek(
                            paginationEntity: entity,
                            pagingController: _pagingController,
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 4,
                    ),
                    child: Text(
                      'filter'.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ]),
              body: PagedListView<int, WeeklyPan>(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<WeeklyPan>(
                      noItemsFoundIndicatorBuilder: (context) => Center(
                            child: Image.asset('assets/images/add.png'),
                          ),
                      itemBuilder: (context, item, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Plans(
                                      weekId: item,
                                    )));
                          },
                          leading: Image.asset(AppIcon.pdf),
                          title: Text(
                            item.weekNumberText,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          subtitle: Text(
                            "${"num_plans".tr()} ${item.weeklyPlansCount}",
                            // textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        );
                      })),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
