import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/circular_model.dart';
import 'package:adary/features/adary/domain/entities/file_download_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_circulars_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/circular/circular_bloc.dart';
import 'package:adary/features/adary/presentation/pages/add_circale.dart';
import 'package:adary/features/adary/presentation/widgets/visits/item_cicular.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class CircularPage extends StatefulWidget {
  const CircularPage({super.key});

  @override
  State<CircularPage> createState() => _CircularPageState();
}

class _CircularPageState extends State<CircularPage> {
  final PagingController<int, AdministrativeCircular> _pagingController =
      PagingController(firstPageKey: 1);
  late PaginationEntity entity;

  final getModel20useCase = sl<GetCircularsUseCase>();
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
      create: (context) => sl<CircularBloc>(),
      child: BlocBuilder<CircularBloc, CircularState>(
        builder: (context, state) {
          if (state is DoneDeleteCircularState) {
            AppUtils.showCustomSnackbar(
                'deleted_health'.tr(), SnackType.SUCESS);
            _pagingController.refresh();
          } else if (state is ExportCirculasPdfState) {
            OpenFilex.open(state.eneity.pathDownload);
          }
          return SafeArea(
            child: Scaffold(
              bottomNavigationBar: BottomNavigatorBar(
                items: [
                  Expanded(
                    child: BtnApp(
                      onTap: () async {
                        final tempDir = await getTemporaryDirectory();

                        final filePath = '${tempDir.path}/visits.pdf';
                        BaseBloc.get<CircularBloc>(context).add(
                            ExportCirculasPdfEvent(
                                eneity: FileDownloadEneity(
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
              appBar: MyAppBar(title: 'circulars'.tr(), actions: [
                IconButton(
                  onPressed: () {
                    AppUtils.go(AddCircale(
                      pagingController: _pagingController,
                    ));
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.APP_COLOR,
                    ),
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ]),
              body: PagedListView<int, AdministrativeCircular>(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  pagingController: _pagingController,
                  builderDelegate:
                      PagedChildBuilderDelegate<AdministrativeCircular>(
                          noItemsFoundIndicatorBuilder: (context) => Center(
                                child: Image.asset('assets/images/add.png'),
                              ),
                          itemBuilder: (context, item, index) {
                            return ItemCicular(
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
