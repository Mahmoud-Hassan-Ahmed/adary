import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/icons.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/class_health.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/presentation/bloc/health/health_bloc.dart';
import 'package:adary/features/adary/presentation/pages/add_heath_page.dart';
import 'package:adary/features/adary/presentation/pages/healthes.dart';
import 'package:adary/features/table/utils/app_colors.dart';
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
              appBar: MyAppBar(title: 'healths'.tr(), actions: [
                if (AppUtils.checkPermission(['/health/add-health/']))
                  IconButton(
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
                      icon: SvgPicture.asset("assets/icons/icon-add.svg"))
              ]),
              bottomNavigationBar: BottomNavigatorBar(
                items: [
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: BtnApp(
                      padding: const EdgeInsets.symmetric(vertical: 17),
                      icon: "assets/icons/material-symbols_download.svg",
                      onTap: () async {
                        final tempDir = await getTemporaryDirectory();

                        final filePath = '${tempDir.path}/healths.pdf';
                        BaseBloc.get<HealthBloc>(context).add(ExportPfdEvent(
                            baseEnity: FileDownloadEneity(
                                id: 0, pathDownload: filePath)));
                      },
                      label: 'تصدير ملف Pdf ',
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset("assets/icons/icon-search.svg"))
                ],
              ),

              // bottomNavigationBar: BottomNavigatorBar(items: [
              //   if (AppUtils.permissions.isNotEmpty &&
              //           AppUtils.permissions
              //               .any((p) => p.contains("/api/notes/add_health/")) ||
              //       AppUtils.permissions.isEmpty)
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: () {
              //           showModalBottomSheet(
              //             isScrollControlled: true,
              //             context: context,
              //             builder: (context) {
              //               return AddHeathPage(
              //                 refreshKey: _refreshIndicatorKey,
              //               );
              //             },
              //           );
              //         },
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.black,
              //           elevation: 4,
              //         ),
              //         child: Text(
              //           'new_health'.tr(),
              //           style: const TextStyle(color: Colors.white),
              //         ),
              //       ),
              //     ),
              //   if (AppUtils.permissions.isNotEmpty &&
              //           AppUtils.permissions.any(
              //               (p) => p.contains("api/notes/healths/download/")) ||
              //       AppUtils.permissions.isEmpty)
              //     Builder(builder: (context) {
              //       return Expanded(
              //         child: TextButton(
              //           onPressed: () async {
              //             final tempDir = await getTemporaryDirectory();

              //             final filePath = '${tempDir.path}/healths.pdf';
              //             BaseBloc.get<HealthBloc>(context).add(ExportPfdEvent(
              //                 baseEnity: FileDownloadEneity(
              //                     id: 0, pathDownload: filePath)));
              //           },
              //           child: Text(
              //             '${'export'.tr()} PDF',
              //             style: AbhayaLibreSemiBold.copyWith(
              //                 color: Colors.black,
              //                 decoration: TextDecoration.underline),
              //           ),
              //         ),
              //       );
              //     }),
              // ]),

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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    classes[index].healthCount > 0
                                        ? '${classes[index].healthCount} ${'status'.tr()}'
                                        : 'no_exit_status'.tr(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                            fontSize: 14,
                                            color:
                                                classes[index].healthCount > 0
                                                    ? Colors.red
                                                    : Colors.black),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  SvgPicture.asset(
                                    AppIcon.go,
                                    color: AppColors.SECONDERYCOLOR,
                                  ),
                                ],
                              ),
                              title: Text(
                                classes[index].name,
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            ),
                        separatorBuilder: (context, index) => const Divider(
                              height: 1,
                              indent: 16,
                              endIndent: 16,
                              color: AppColors.SECONDERYCOLOR,
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
