import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/details_audience.dart';
import 'package:adary/features/adary/data/models/student_model.dart';
import 'package:adary/features/adary/data/models/student_per.dart';
import 'package:adary/features/adary/domain/entities/filter_per.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/entities/register_student_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_student_attendnce.dart';
import 'package:adary/features/adary/domain/usecases/get_student_calss_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_students_use_case.dart';
import 'package:adary/features/adary/domain/usecases/register_students_use_case.dart';
import 'package:adary/features/adary/presentation/pages/done_added_page.dart';
import 'package:adary/features/adary/presentation/widgets/perseverance/StudentCard.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Audience extends StatefulWidget {
  const Audience(
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
  State<Audience> createState() => _AudienceState();
}

class _AudienceState extends State<Audience> {
  final PagingController<int, StudentPer> _pagingController =
      PagingController(firstPageKey: 1);
  final PagingController<int, StudentInfo> _pagingController1 =
      PagingController(firstPageKey: 1);
  late FilterPer entity;
  late FilterPer entity1;
  final getstudents = sl<GetStudentAttendnce>();
  final geStudentsByClass = sl<GetStudentCalssUseCase>();
  final List<RegisterStudentEntity> entites = [];
  @override
  void initState() {
    AppUtils.log('initState');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(DetailsAudience(
                dateTime: widget.dateTime ?? DateTime.now(),
                session: widget.sessionName ?? '',
                className: widget.className ?? '',
                numAud: _pagingController.itemList
                        ?.where((t) => t.attendance == 's')
                        .length ??
                    0,
                numaAbsent: _pagingController.itemList
                        ?.where((t) => t.attendance == 'a')
                        .length ??
                    0,
                numLate: _pagingController.itemList
                        ?.where((t) => t.attendance == ';')
                        .length ??
                    0,
                permission: _pagingController.itemList
                        ?.where((t) => t.attendance == 'p')
                        .length ??
                    0)),
            const SizedBox(height: 10),
            Expanded(
              child: widget.isView
                  ? PagedListView<int, StudentPer>(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      physics: const BouncingScrollPhysics(),
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<StudentPer>(
                          noItemsFoundIndicatorBuilder: (context) => Center(
                                child: Image.asset('assets/images/add.png'),
                              ),
                          itemBuilder: (context, item, index) {
                            return StudentCard(
                              studentAud: item,
                            );
                          }))
                  : Column(
                      children: [
                        Expanded(
                          child: PagedListView<int, StudentInfo>(
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              pagingController: _pagingController1,
                              builderDelegate:
                                  PagedChildBuilderDelegate<StudentInfo>(
                                      noItemsFoundIndicatorBuilder: (context) =>
                                          Center(
                                            child: Image.asset(
                                                'assets/images/add.png'),
                                          ),
                                      itemBuilder: (context, item, index) {
                                        final register = RegisterStudentEntity(
                                          studentId: item.id,
                                          date:
                                              widget.dateTime ?? DateTime.now(),
                                          dateHijri: widget.date ?? '1/1/1111',
                                          className: widget.classId ?? 9,
                                          session: widget.session ?? 9,
                                        );
                                        entites.add(register);
                                        return StudentCardRegister(
                                          student: item,
                                          index: index,
                                          onChange: (value) {
                                            register.attendance = value.$1;
                                            register.note = value.$2;
                                          },
                                        );
                                      })),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: BtnApp(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                              label: 'حفظ التسجيل ',
                              onTap: () async {
                                await sl<RegisterStudentsUseCase>()
                                    .call(entites);
                                AppUtils.go(const DoneAddedPage(
                                    label: 'تم تسجيل الحضور    ',
                                    title: 'تسجيل الحضور   '));
                              }),
                        )
                      ],
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(DetailsAudience details) {
    return Container(
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
                  const Text("التاريخ: "),
                  Text(
                    DateFormat('dd/MM/yyyy').format(details.dateTime),
                    style: TextStyle(color: AppColors.APP_COLOR),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("الحصة: "),
                  Text(
                    details.session,
                    style: TextStyle(color: AppColors.APP_COLOR),
                  ),
                ],
              ),
              Row(
                children: [
                  const Text("الفصل: "),
                  Text(
                    details.className,
                    style: TextStyle(color: AppColors.APP_COLOR),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// Status Counters
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatusItem("${details.numAud} حاضر", Colors.green),
              _StatusItem("${details.numaAbsent} غائب", Colors.red),
              _StatusItem("${details.numLate} متأخر", Colors.orange),
              _StatusItem("${details.permission} مستأذن", Colors.indigo),
            ],
          ),

          const SizedBox(height: 8),

          /// Title
          const Row(
            children: [
              Icon(Icons.group, size: 18),
              SizedBox(width: 6),
              Text("أسماء الطلاب"),
            ],
          )
        ],
      ),
    );
  }
}

/// 🔹 Status Counter Widget
class _StatusItem extends StatelessWidget {
  final String text;
  final Color color;

  const _StatusItem(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: color, fontSize: 12),
        )
      ],
    );
  }
}

/// 🔹 Student Card
class StudentCard extends StatelessWidget {
  final StudentPer studentAud;

  const StudentCard({super.key, required this.studentAud});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            blurRadius: 6,
            offset: Offset(0, 2),
            color: Colors.black12,
          )
        ],
      ),
      child: Row(
        children: [
          /// Status Text (Left)

          /// Avatar
          const CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage("assets/images/student.jpg"),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                studentAud.student.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                studentAud.note ?? '',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          const Spacer(),

          Text(
            studentAud.statusName,
            style: TextStyle(
              color: studentAud.color,
              fontWeight: FontWeight.bold,
            ),
          ),

          /// Student Info
        ],
      ),
    );
  }
}
