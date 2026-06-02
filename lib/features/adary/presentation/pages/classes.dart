import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/student_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_students_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/class_visit/class_visit_bloc.dart';
import 'package:adary/features/adary/presentation/pages/add_social.dart';
import 'package:adary/features/adary/presentation/widgets/social/item_student.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:open_filex/open_filex.dart';

class ClassesList extends StatefulWidget {
  const ClassesList({super.key});

  @override
  State<ClassesList> createState() => _ClassesListState();
}

class _ClassesListState extends State<ClassesList> {
  final PagingController<int, StudentModel> _pagingController =
      PagingController(firstPageKey: 1);
  final entity = PaginationEntity(page: 1);
  final getModel20useCase = sl<GetStudentsUseCase>();
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
      create: (context) => sl<ClassVisitBloc>(),
      child: BlocBuilder<ClassVisitBloc, ClassVisitState>(
        builder: (context, state) {
          if (state is DoneDeleteStudentState) {
            AppUtils.showCustomSnackbar(
                'deleted_student'.tr(), SnackType.SUCESS);
            _pagingController.refresh();
          }
          if (state is DoneDeleteVisitState) {
            AppUtils.showCustomSnackbar('deleted_visit'.tr(), SnackType.SUCESS);
            _pagingController.refresh();
          } else if (state is ExportVisitsState) {
            OpenFilex.open(state.fileDownloadEneity.pathDownload);
          }
          return SafeArea(
            child: Scaffold(
              appBar: MyAppBar(title: 'MaritalStatus'.tr(), actions: [
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return AddSocial(
                            pagingController: _pagingController,
                          );
                        },
                      );
                    },
                    icon: SvgPicture.asset("assets/icons/icon-add.svg"))
              ]),
              // bottomNavigationBar: BottomNavigatorBar(items: [
              //   if (AppUtils.permissions.isNotEmpty &&
              //           AppUtils.permissions
              //               .any((p) => p.contains("/api/notes/add_social/")) ||
              //       AppUtils.permissions.isEmpty)
              //     Expanded(
              //       child: BtnApp(label: 'add student'.tr(), onTap: () {}),
              //     )
              // ]),
              body: PagedListView<int, StudentModel>(
                  padding: const EdgeInsets.all(10),
                  physics: const BouncingScrollPhysics(),
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<StudentModel>(
                      noItemsFoundIndicatorBuilder: (context) => Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset('assets/images/add.png'),
                                const SizedBox(
                                  height: 10,
                                ),
                                const LabelMainText(
                                  text: 'لا يوجد حالات إجتماعية للعرض',
                                  color: Colors.black,
                                )
                              ],
                            ),
                          ),
                      itemBuilder: (context, item, index) {
                        return ItemsStudent(
                          studentModel: item,
                          pagingController: _pagingController,
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
