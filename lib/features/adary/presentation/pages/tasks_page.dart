import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/task_model.dart';
import 'package:adary/features/adary/presentation/bloc/task/task_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/task/add_task.dart'
    as add;
import 'package:adary/features/adary/presentation/widgets/task/item_task_n.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();
    List<TaskModel>? tasks;
    return BlocProvider(
      create: (context) => sl<TaskBloc>(),
      child: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TaskInitial) {
            BaseBloc.get<TaskBloc>(context).add(GetTasksEvent());
          } else if (state is DoneDeletTask) {
            AppUtils.showCustomSnackbar(
                'deleted_mission'.tr(), SnackType.SUCESS);
            BaseBloc.get<TaskBloc>(context).add(GetTasksEvent());
          } else if (state is GetTasksState) {
            tasks = state.task;
          }
          return SafeArea(
            child: Scaffold(
              appBar: MyAppBar(title: 'missions'.tr(), actions: [
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return add.AddTask(fun: () {
                            _refreshIndicatorKey.currentState?.show();
                          });
                        },
                      );
                    },
                    icon: SvgPicture.asset("assets/icons/icon-add.svg"))
              ]),
              // bottomNavigationBar: BottomNavigatorBar(items: [
              //   if (AppUtils.permissions.isNotEmpty &&
              //           AppUtils.permissions
              //               .any((p) => p.contains("/api/daily-tasks/add/")) ||
              //       AppUtils.permissions.isEmpty)
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: () {
              //           showModalBottomSheet(
              //             isScrollControlled: true,
              //             context: context,
              //             builder: (context) {
              //               return add.AddTask(fun: () {
              //                 _refreshIndicatorKey.currentState?.show();
              //               });
              //             },
              //           );
              //         },
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.black,
              //           elevation: 4,
              //         ),
              //         child: Text(
              //           'new_missiom'.tr(),
              //           style: const TextStyle(color: Colors.white),
              //         ),
              //       ),
              //     ),
              // ]),

              body: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  BaseBloc.get<TaskBloc>(context).add(GetTasksEvent());
                },
                child: tasks == null
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: tasks!.length,
                        itemBuilder: (context, index) => ItemTaskN(
                          visitModel: tasks![index],
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
