import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/class_room.dart';
import 'package:adary/features/adary/presentation/bloc/students/students_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/admin_prepation/add_class.dart';
import 'package:adary/features/adary/presentation/widgets/social/item_class.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClassRoomPage extends StatelessWidget {
  const ClassRoomPage({super.key});
  static BuildContext? context;
  @override
  Widget build(BuildContext context) {
    List<Classroom> classes = [];
    return BlocProvider(
      create: (context) => sl<StudentsBloc>(),
      child: BlocBuilder<StudentsBloc, StudentsState>(
        builder: (context, state) {
          ClassRoomPage.context = context;
          if (state is StudentsInitial) {
            BaseBloc.get<StudentsBloc>(context).add(GetClassesRoomEvent());
          } else if (state is DoneGetClassRoomState) {
            classes = state.list;
          } else if (state is DoneDeleteClassState) {
            AppUtils.showCustomSnackbar('deleted_class'.tr(), SnackType.SUCESS);
            BaseBloc.get<StudentsBloc>(context).add(GetClassesRoomEvent());
          } else if (state is DoneAddClassState) {
            BaseBloc.get<StudentsBloc>(context).add(GetClassesRoomEvent());
          } else if (state is DoneUpdateClassState) {
            BaseBloc.get<StudentsBloc>(context).add(GetClassesRoomEvent());
          }
          return SafeArea(
            child: Scaffold(
              appBar: MyAppBar(title: 'classes'.tr()),
              bottomNavigationBar: BottomNavigatorBar(items: [
                Expanded(
                  child: BtnApp(
                      label: 'add_class'.tr(),
                      onTap: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return const AddClass();
                          },
                        );
                      }),
                )
              ]),
              body: RefreshIndicator(
                onRefresh: () async {
                  BaseBloc.get<StudentsBloc>(context)
                      .add(GetClassesRoomEvent());
                },
                child: classes.isNotEmpty
                    ? ListView.separated(
                        itemBuilder: (context, index) =>
                            ItemClass(item: classes[index]),
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                        itemCount: classes.length)
                    : Center(
                        child: Image.asset('assets/images/add.png'),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }
}
