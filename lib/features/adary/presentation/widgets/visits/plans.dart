import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/week_plan.dart';
import 'package:adary/features/adary/data/models/weekly_pan.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_week_palnes_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/week_plan/week_plan_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/visits/item_week_paln.dart';
import 'package:adary/features/adary/presentation/widgets/week_plans/Pdf_card.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../core/share/widgets/my_app_bar.dart';

class Plans extends StatefulWidget {
  const Plans({super.key, required this.weekId});
  final WeeklyPan weekId;

  @override
  State<Plans> createState() => _PlansState();
}

class _PlansState extends State<Plans> {
  final PagingController<int, Plan> _pagingController =
      PagingController(firstPageKey: 1);
  late PaginationEntity entity;

  final getModel20useCase = sl<GetWeekPalnesUseCase>();
  @override
  void initState() {
    entity = PaginationEntity(page: 1, classId: widget.weekId.id);
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
      create: (context) => sl<WeekPlanBloc>(),
      child: BlocBuilder<WeekPlanBloc, WeekPlanState>(
        builder: (context, state) {
          if (state is DoneDeletePlanState) {
            AppUtils.showCustomSnackbar('تم مسج الخطه بنجاح', SnackType.SUCESS);
            _pagingController.refresh();
          }
          return SafeArea(
            child: Scaffold(
              appBar: MyAppBar(
                title: widget.weekId.weekNumberText.toString(),
              ),
              body: PagedGridView<int, Plan>(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                pagingController: _pagingController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 👈 3 items per row
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.6, // adjust based on your PDF card height
                ),
                builderDelegate: PagedChildBuilderDelegate<Plan>(
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Image.asset('assets/images/add.png'),
                  ),
                  itemBuilder: (context, item, index) {
                    return PdfCardWithFlutterPdfView(
                      pdfUrl: item.file,
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
