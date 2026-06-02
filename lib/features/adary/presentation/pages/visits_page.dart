import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/visits_model.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_visits_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/class_visit/class_visit_bloc.dart';
import 'package:adary/features/adary/presentation/pages/class_visit.dart';
import 'package:adary/features/adary/presentation/widgets/admin_prepation/note_exit.dart';
import 'package:adary/features/adary/presentation/widgets/visits/item_visit.dart';
import 'package:adary/features/adary/presentation/widgets/visits/plan_visit.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class VisitsPage extends StatefulWidget {
  const VisitsPage({super.key});

  @override
  State<VisitsPage> createState() => _VisitsPageState();
}

class _VisitsPageState extends State<VisitsPage> {
  final PagingController<int, VisitModel> _pagingController =
      PagingController(firstPageKey: 1);
  final entity = PaginationEntity(page: 1);
  final getModel20useCase = sl<GetVisitsUseCase>();
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
          if (state is DoneDeleteVisitState) {
            AppUtils.showCustomSnackbar('deleted_visit'.tr(), SnackType.SUCESS);
            _pagingController.refresh();
          } else if (state is ExportVisitsState) {
            OpenFilex.open(state.fileDownloadEneity.pathDownload);
          } else if (state is DoneGetIdEvaluationState) {
            WidgetsBinding.instance.addPostFrameCallback((callback) {
              AppUtils.go(RatingPage(visit: state.visit));
            });
          }
          return SafeArea(
            child: Scaffold(
              appBar: MyAppBar(title: 'الزيارات الصفية'.tr(), actions: [
                IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context) {
                          return AddClassVisit(
                            pagingController: _pagingController,
                          );
                        },
                      );
                    },
                    icon: SvgPicture.asset('assets/icons/icon-btn-add.svg'))
              ]),
              bottomNavigationBar: BottomNavigatorBar(
                items: [
                  Expanded(
                    child: BtnApp(
                      onTap: () async {
                        final tempDir = await getTemporaryDirectory();

                        final filePath = '${tempDir.path}/visits.pdf';
                        BaseBloc.get<ClassVisitBloc>(context).add(
                            ExportVisitsEvent(
                                fileDownloadEneity: FileDownloadEneity(
                                    id: 0, pathDownload: filePath)));
                      },
                      label: '${'export'.tr()} PDF'.tr(),
                    ),
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: SvgPicture.asset("assets/icons/icon-search.svg"))
                ],
              ),
              body: PagedListView<int, VisitModel>(
                  padding: const EdgeInsets.all(10),
                  physics: const BouncingScrollPhysics(),
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<VisitModel>(
                      noItemsFoundIndicatorBuilder: (context) =>
                          const NoteExit(),
                      itemBuilder: (context, item, index) {
                        return ItemVisit(
                          visitModel: item,
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
