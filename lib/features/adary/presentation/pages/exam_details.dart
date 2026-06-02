import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/class_health.dart';
import 'package:adary/features/adary/data/models/exam_model.dart';
import 'package:adary/features/adary/data/models/health_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_exam_by_day_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_exams_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_healths_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/exam/exam_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/health/health_bloc.dart';
import 'package:adary/features/adary/presentation/pages/HalsDetails.dart';
import 'package:adary/features/adary/presentation/widgets/exam/AddExam.dart';
import 'package:adary/features/adary/presentation/widgets/exam/CommitteeCard.dart';
import 'package:adary/features/adary/presentation/widgets/exam/ExamCard.dart';
import 'package:adary/features/adary/presentation/widgets/exam/ExamCommitteeItem.dart';
import 'package:adary/features/adary/presentation/widgets/health/health_item.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ExamDetails extends StatefulWidget {
  const ExamDetails({super.key, required this.exam});
  final Exam exam;

  State<ExamDetails> createState() => ExaminationState();
}

class ExaminationState extends State<ExamDetails> {
  final PagingController<int, ExamDay> _pagingController =
      PagingController(firstPageKey: 1);
  late PaginationEntity entity;

  final getModel20useCase = sl<GetExamByDayUseCase>();
  @override
  void initState() {
    entity = PaginationEntity(page: 1, classId: widget.exam.id);
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
      create: (context) => sl<ExamBloc>(),
      child: BlocBuilder<ExamBloc, ExamState>(
        builder: (context, state) {
          // if (state is DoneDeleteHealthState) {
          //   AppUtils.showCustomSnackbar(
          //       'deleted_health'.tr(), SnackType.SUCESS);
          //   _pagingController.refresh();
          // }
          return SafeArea(
            child: Scaffold(
              appBar: MyAppBar(
                  title: 'لجنة اختبارات الفصل الدراسي التاني ',
                  actions: [
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          isScrollControlled: true,
                          context: context,
                          builder: (context) {
                            return const AddExam();
                          },
                        );
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
              // body: ListView.builder(
              //   itemCount: 5,
              //   itemBuilder: (context, index) => const CommitteeCard(),
              // ),
              body: PagedListView<int, ExamDay>(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<ExamDay>(
                      noItemsFoundIndicatorBuilder: (context) => Center(
                            child: Image.asset('assets/images/add.png'),
                          ),
                      itemBuilder: (context, item, index) {
                        return InkWell(
                          onTap: () {
                            AppUtils.go(HalsDetails(
                              exam: widget.exam,
                              examDay: item,
                            ));
                          },
                          child: ExamItemWidget(
                            index: index + 1,
                            title: widget.exam.name,
                            date:
                                "تاريخ البدء من ${DateFormat('dd/MM/yyyy').format(widget.exam.startDate)} حتى ${DateFormat('dd/MM/yyyy').format(widget.exam.endDate)}",
                            description: widget.exam.description ?? '',
                            committeesCount: item.halls.length,
                          ),
                        );
                        // return Column(
                        //   children: item.halls
                        //       .map((e) => CommitteeCard(
                        //             examDay: item,
                        //             hall: e,
                        //             exam: widget.exam,
                        //           ))
                        //       .toList(),
                        // );
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
