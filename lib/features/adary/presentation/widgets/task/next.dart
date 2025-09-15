import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/task_teacher_mdel.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_task_teacher_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/class_visit/class_visit_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/delay_task/delay_task_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/task/add_task_teacher.dart';
import 'package:adary/features/adary/presentation/widgets/task/item_task.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:open_filex/open_filex.dart';

import '../../../../../core/conts/app_colors.dart';

class NextTask extends StatefulWidget {
  const NextTask({super.key});

  @override
  State<NextTask> createState() => _NextTaskState();
}

class _NextTaskState extends State<NextTask> {
  final PagingController<int, DailyTaskModel> _pagingController =
      PagingController(firstPageKey: 1);
  final entity = PaginationEntity(page: 1, endDate: 'upcomming');
  final getModel20useCase = sl<GetTaskTeacherUseCase>();
  @override
  void initState() {
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
      create: (context) => sl<DelayTaskBloc>(),
      child: BlocBuilder<DelayTaskBloc, DelayTaskState>(
        builder: (context, state) {
          if (state is DobneRemoveTaskTeacherState) {
            AppUtils.showCustomSnackbar(
                'deleted_mission'.tr(), SnackType.SUCESS);
            _pagingController.refresh();
          }
          return SafeArea(
            child: Scaffold(
              bottomNavigationBar: BottomNavigatorBar(items: [
                Expanded(
                  child: BtnApp(
                      label: 'new_mission'.tr(),
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return AddTeacherTask(
                              pagingController: _pagingController,
                            );
                          },
                        );
                      }),
                )
              ]),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: PagedListView<int, DailyTaskModel>(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    pagingController: _pagingController,
                    builderDelegate: PagedChildBuilderDelegate<DailyTaskModel>(
                        noItemsFoundIndicatorBuilder: (context) => Center(
                              child: Image.asset('assets/images/add.png'),
                            ),
                        itemBuilder: (context, item, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.date,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .copyWith(color: AppColors.FONTCOLOR),
                              ),
                              ...item.dailyTasks.map((e) => ItemTask(
                                    canDekete: true,
                                    visitModel: e,
                                    pagingController: _pagingController,
                                  ))
                            ],
                          );
                        })),
              ),
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
