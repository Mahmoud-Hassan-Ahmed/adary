import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/class_health.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/presentation/bloc/health/health_bloc.dart';
import 'package:adary/features/adary/presentation/pages/add_heath_page.dart';
import 'package:adary/features/adary/presentation/pages/healthes.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ClassHealthPage extends StatelessWidget {
  const ClassHealthPage({super.key});
  static BuildContext? context;
  @override
  Widget build(BuildContext context) {
    List<ClassHealth> classes = [];
    final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>();
    return BlocProvider(
      create: (context) => sl<HealthBloc>(),
      child: BlocBuilder<HealthBloc, HealthState>(
        builder: (context, state) {
          ClassHealthPage.context = context;
          if (state is HealthInitial) {
            BaseBloc.get<HealthBloc>(context).add(GetClassHealthsEvent());
          } else if (state is DoneClassHealthstate) {
            classes = state.list;
          } else if (state is ExportPfdState) {
            OpenFilex.open(state.baseEnity.pathDownload);
          }
          return SafeArea(
            child: Scaffold(
              appBar: MyAppBar(title: 'healths'.tr()),
              bottomNavigationBar: BottomNavigatorBar(items: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return AddHeathPage(
                            refreshKey: _refreshIndicatorKey,
                          );
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 4,
                    ),
                    child: Text(
                      'new_health'.tr(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Builder(builder: (context) {
                  return Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final tempDir = await getTemporaryDirectory();

                        final filePath = '${tempDir.path}/healths.pdf';
                        BaseBloc.get<HealthBloc>(context).add(ExportPfdEvent(
                            baseEnity: FileDownloadEneity(
                                id: 0, pathDownload: filePath)));
                      },
                      child: Text(
                        '${'export'.tr()} PDF',
                        style: AbhayaLibreSemiBold.copyWith(
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  );
                }),
              ]),
              body: RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: () async {
                  BaseBloc.get<HealthBloc>(context).add(GetClassHealthsEvent());
                },
                child: classes.isNotEmpty
                    ? ListView.separated(
                        itemBuilder: (context, index) => ListTile(
                              onTap: () {
                                AppUtils.go(HealthesPage(
                                  classId: classes[index],
                                ));
                              },
                              trailing: SvgPicture.asset(AppIcon.go),
                              title: Text(
                                classes[index].name,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              subtitle: Text(
                                classes[index].healthCount > 0
                                    ? '${'state'.tr()} ${classes[index].healthCount}'
                                    : 'لا يوجد حالات',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .copyWith(
                                        color: classes[index].healthCount > 0
                                            ? Colors.red
                                            : Colors.black),
                              ),
                            ),
                        separatorBuilder: (context, index) => const Divider(),
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
