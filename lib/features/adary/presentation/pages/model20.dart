import 'dart:io';

import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/model_20.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_model20_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/model20/model20_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/admin_prepation/add_model20.dart';
import 'package:adary/features/adary/presentation/widgets/admin_prepation/item_mdoel_20.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:open_filex/open_filex.dart';
import 'package:printing/printing.dart';

class Model20Page extends StatefulWidget {
  const Model20Page({super.key});

  @override
  State<Model20Page> createState() => _Model20PageState();
}

class _Model20PageState extends State<Model20Page> {
  final PagingController<int, Model20Model> _pagingController =
      PagingController(firstPageKey: 1);
  final entity = PaginationEntity(page: 1);
  final getModel20useCase = sl<GetModel20UseCase>();
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

  _print(String path) async {
    final file = File(path);
    final byes = await file.readAsBytes();
    await Printing.layoutPdf(onLayout: (_) => byes);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<Model20Bloc>(),
      child: BlocBuilder<Model20Bloc, Model20State>(
        builder: (context, state) {
          if (state is DownloadFileState) {
            if (state.fileDownloadEneity.print) {
              _print(state.fileDownloadEneity.pathDownload);
            } else {
              AppUtils.showCustomSnackbar(
                  '${'downloed_file'.tr()} ${state.fileDownloadEneity.pathDownload}',
                  SnackType.SUCESS);
              OpenFilex.open(state.fileDownloadEneity.pathDownload);
            }
          } else if (state is DoneDeleteModel20) {
            _pagingController.refresh();
            AppUtils.showCustomSnackbar('deleted_model'.tr(), SnackType.SUCESS);
          }
          return SafeArea(
            child: Scaffold(
              bottomNavigationBar: BottomNavigatorBar(items: [
                if (AppUtils.permissions.isNotEmpty &&
                        AppUtils.permissions
                            .any((p) => p.contains('api/notes/model19/add/')) ||
                    AppUtils.permissions.isEmpty)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return AddModel20(
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
                        'note'.tr(),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                // TextButton(
                //   onPressed: () {},
                //   child: Text(
                //     'تصدير PDF',
                //     style: AbhayaLibreSemiBold.copyWith(
                //         color: Colors.black,
                //         decoration: TextDecoration.underline),
                //   ),
                // ),
              ]),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'model19'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.checkbox),
                    ),
                  ),
                  Expanded(
                    child: PagedListView<int, Model20Model>(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        pagingController: _pagingController,
                        builderDelegate: PagedChildBuilderDelegate<
                                Model20Model>(
                            noItemsFoundIndicatorBuilder: (context) => Center(
                                  child: Image.asset('assets/images/add.png'),
                                ),
                            itemBuilder: (context, item, index) {
                              return ItemModel20(
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
