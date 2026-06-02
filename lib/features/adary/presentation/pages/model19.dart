import 'dart:io';
import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/model_19.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_model19_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/model19/model19_bloc.dart';
import 'package:adary/features/adary/presentation/pages/admin_prepation.dart';
import 'package:adary/features/adary/presentation/widgets/admin_prepation/add_model19.dart';
import 'package:adary/features/adary/presentation/widgets/admin_prepation/item_model19.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:open_filex/open_filex.dart';
import 'package:printing/printing.dart';

class Model19Page extends StatefulWidget {
  const Model19Page({super.key});

  @override
  State<Model19Page> createState() => _Model19PageState();
}

class _Model19PageState extends State<Model19Page> {
  final PagingController<int, Model19Model> _pagingController =
      PagingController(firstPageKey: 1);
  final entity = PaginationEntity(page: 1);
  final getModel19useCase = sl<GetModel19UseCase>();
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    var result = await getModel19useCase(entity..page = pageKey);
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
    }
  }

  _print(String path) async {
    final file = File(path);
    final byes = await file.readAsBytes();
    await Printing.layoutPdf(onLayout: (_) => byes);
  }

  @override
  Widget build(BuildContext context) {
    AdminPrepation.pagingController = _pagingController;

    return BlocProvider(
      create: (context) => sl<Model19Bloc>(),
      child: BlocBuilder<Model19Bloc, Model19State>(
        builder: (context, state) {
          if (state is DownloadFileState) {
            if (state.fileDownloadEneity.print) {
              _print(state.fileDownloadEneity.pathDownload);
            } else {
              AppUtils.showCustomSnackbar(
                  '${'downloaded_file'.tr()} ${state.fileDownloadEneity.pathDownload}',
                  SnackType.SUCESS);
              OpenFilex.open(state.fileDownloadEneity.pathDownload);
            }
          } else if (state is DoneDeleteModel19state) {
            _pagingController.refresh();
            AppUtils.showCustomSnackbar('deleted_model'.tr(), SnackType.SUCESS);
          }
          return SafeArea(
            child: Scaffold(
              // bottomNavigationBar: BottomNavigatorBar(items: [
              //   if (AppUtils.permissions.isNotEmpty &&
              //           AppUtils.permissions
              //               .any((p) => p.contains('api/notes/model20/add/')) ||
              //       AppUtils.permissions.isEmpty)
              //     Expanded(
              //       child: ElevatedButton(
              //         onPressed: () {
              //           showModalBottomSheet(
              //             isScrollControlled: true,
              //             context: context,
              //             builder: (context) {
              //               return AddModel19(
              //                 pagingController: _pagingController,
              //               );
              //             },
              //           );
              //         },
              //         style: ElevatedButton.styleFrom(
              //           backgroundColor: Colors.black,
              //           elevation: 4,
              //         ),
              //         child: Text(
              //           'desi'.tr(),
              //           style: TextStyle(color: Colors.white),
              //         ),
              //       ),
              //     ),
              //   // TextButton(
              //   //   onPressed: () {},
              //   //   child: Text(
              //   //     'تصدير PDF',
              //   //     style: AbhayaLibreSemiBold.copyWith(
              //   //         color: Colors.black,
              //   //         decoration: TextDecoration.underline),
              //   //   ),
              //   // ),
              // ]),

              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'model20'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.checkbox),
                    ),
                  ),
                  Expanded(
                    child: PagedListView<int, Model19Model>(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        pagingController: _pagingController,
                        builderDelegate: PagedChildBuilderDelegate<
                                Model19Model>(
                            noItemsFoundIndicatorBuilder: (context) => Center(
                                  child: Image.asset('assets/images/add.png'),
                                ),
                            itemBuilder: (context, item, index) {
                              return ItemModel19(
                                item: item,
                                pagingController: _pagingController,
                              );
                            })),
                  ),
                ],
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
