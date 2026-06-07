import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/features/adary/data/models/student_per.dart';
import 'package:adary/features/adary/domain/entities/filter_per.dart';
import 'package:adary/features/adary/domain/entities/register_student_entity.dart';
import 'package:adary/features/adary/domain/usecases/add_behavoir_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_student_calss_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_students_behavoir.dart';
import 'package:adary/features/adary/presentation/bloc/behavoir_notes/behavoir_notes_bloc.dart';
import 'package:adary/features/adary/presentation/pages/done_added_page.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/StudentPointsCard%20.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/student_note_card.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/utils/app_utils.dart';

class Behavior extends StatefulWidget {
  const Behavior(
      {super.key,
      required this.isView,
      this.classId,
      this.date,
      this.sessionName,
      this.className,
      this.session,
      this.dateTime});
  final bool isView;
  final int? classId;
  final String? date;
  final int? session;
  final String? sessionName;
  final String? className;
  final DateTime? dateTime;

  @override
  State<Behavior> createState() => _BehaviorState();
}

class _BehaviorState extends State<Behavior> {
  final PagingController<int, StudentBehavior> _pagingController =
      PagingController(firstPageKey: 1);
  final PagingController<int, StudentInfo> _pagingController1 =
      PagingController(firstPageKey: 1);
  late FilterPer entity;
  late FilterPer entity1;
  final getstudents = sl<GetStudentsBehavoir>();
  final geStudentsByClass = sl<GetStudentCalssUseCase>();
  final List<BehavoirRecordEntity> entites = [];
  @override
  void initState() {
    entity = FilterPer(
        page: 1,
        className: widget.classId,
        date: widget.dateTime?.toIso8601String().split('T').first,
        dateHijri: widget.date ?? "1/1/1111",
        school: AppUtils.appUser?.id.toString(),
        session: widget.session);
    entity1 = FilterPer(page: 1, className: widget.classId);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    _pagingController1.addPageRequestListener((pageKey) {
      _fetchPage1(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    var result = await getstudents(entity..page = pageKey);
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

  Future<void> _fetchPage1(int pageKey) async {
    var result = await geStudentsByClass(entity1..page = pageKey);
    try {
      result.fold((l) => null, (paginationModel) {
        final isLastPage = paginationModel.next == null;
        if (isLastPage) {
          _pagingController1.appendLastPage(paginationModel.results);
        } else {
          _pagingController1.appendPage(paginationModel.results, pageKey + 1);
        }
      });
    } catch (error) {
      _pagingController.error = error;
      AppUtils.log(error.toString());
    }
  }

  List<BehaviorNote> notes = [];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BehavoirNotesBloc>(),
      child: BlocBuilder<BehavoirNotesBloc, BehavoirNotesState>(
        builder: (context, state) {
          if (state is BehavoirNotesInitial) {
            BaseBloc.get<BehavoirNotesBloc>(context).add(GetAllNotes());
          } else if (state is DoneGetNotes) {
            notes = state.notes;
          }
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    /// Top Info Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text('${'date'.tr()}: '),
                            Text(
                              DateFormat('dd/MM/yyyy')
                                  .format(widget.dateTime ?? DateTime.now()),
                              style:
                                  const TextStyle(color: AppColors.APP_COLOR),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('${'session'.tr()}: '),
                            Text(
                              widget.sessionName ?? '',
                              style: TextStyle(color: AppColors.APP_COLOR),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text('${'class'.tr()}: '),
                            Text(
                              widget.className ?? '',
                              style: TextStyle(color: AppColors.APP_COLOR),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: widget.isView
                    ? PagedListView<int, StudentBehavior>(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        pagingController: _pagingController,
                        builderDelegate: PagedChildBuilderDelegate<
                                StudentBehavior>(
                            noItemsFoundIndicatorBuilder: (context) => Center(
                                  child: Image.asset('assets/images/add.png'),
                                ),
                            itemBuilder: (context, item, index) {
                              return StudentPointsCard(
                                studentBehavior: item,
                                className: widget.className ?? '',
                              );
                            }))
                    : Column(
                        children: [
                          Expanded(
                            child: PagedListView<int, StudentInfo>(
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                pagingController: _pagingController1,
                                builderDelegate: PagedChildBuilderDelegate<
                                        StudentInfo>(
                                    noItemsFoundIndicatorBuilder: (context) =>
                                        Center(
                                          child: Image.asset(
                                              'assets/images/add.png'),
                                        ),
                                    itemBuilder: (context, item, index) {
                                      final register = BehavoirRecordEntity(
                                        studentId: item.id,
                                        gregorian_date:
                                            widget.dateTime ?? DateTime.now(),
                                        date_hijri: widget.date ?? '1/1/1111',
                                        student_class: widget.classId ?? 9,
                                        period: widget.session ?? 9,
                                      );
                                      entites.add(register);
                                      return StudentNoteCard(
                                        studentInfo: item,
                                        notes: notes,
                                        onchange: (value) {
                                          register.additional_notes =
                                              value.$2 ?? '';
                                          register.notes_ids = [value.$1 ?? 0];
                                          register.submit = value.$3 ?? F;
                                        },
                                      );
                                    })),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: BtnApp(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                label: 'save_record'.tr(),
                                onTap: () async {
                                  await sl<AddBehavoirUseCase>().call(entites);
                                  AppUtils.go(DoneAddedPage(
                                      label: 'behavior_recorded'.tr(),
                                      title: 'record_behavior'.tr()));
                                }),
                          )
                        ],
                      ),
              )

              // ListView(
              //   children: [
              //     if (widget.isView)
              //       const StudentPointsCard(
              //         points: 10,
              //         color: Colors.deepOrange,
              //         name: "محمد احمد علي",
              //       ),
              //     if (!widget.isView) const StudentNoteCard(),
              //     if (widget.isView)
              //       const StudentPointsCard(
              //         points: 10,
              //         color: Colors.green,
              //         name: "محمد احمد علي",
              //       ),
              //   ],
              // ),
            ],
          );
        },
      ),
    );
  }
}
