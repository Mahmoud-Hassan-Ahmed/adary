import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/date_widget.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/note_entity_model.dart';
import 'package:adary/features/adary/data/models/note_teacher.dart';
import 'package:adary/features/adary/data/models/teacher_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_teachers_notes_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/teacher_note/teacher_notes_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/item_teacher_widget.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class NoteTeachersPage extends StatefulWidget {
  const NoteTeachersPage({
    super.key,
  });

  @override
  State<NoteTeachersPage> createState() => _NoteTeachersPageState();
}

class _NoteTeachersPageState extends State<NoteTeachersPage> {
  final PagingController<int, NotesTeacher> _pagingController =
      PagingController(firstPageKey: 1);
  late PaginationEntity entity;
  String selectDate = 'start_end'.tr();
  List<NoteModel> notes = [];
  List<Teacher> teachers = [];
  SelectModel? selected, selected2;

  final getModel20useCase = sl<GetTeachersNotesUseCase>();
  @override
  void initState() {
    entity = PaginationEntity(
      page: 1,
    );
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
      create: (context) => sl<TeacherNotesBloc>(),
      child: BlocBuilder<TeacherNotesBloc, TeacherNotesState>(
        builder: (context, state) {
          if (state is DoneDeleteNoteTeacherState) {
            AppUtils.showCustomSnackbar(
                'deleted_health'.tr(), SnackType.SUCESS);
            _pagingController.refresh();
          } else if (state is TeacherNotesInitial) {
            BaseBloc.get<TeacherNotesBloc>(context).add(GetTeachersEvent());
          } else if (state is DoneGetDataTeachersState) {
            teachers = state.list;
            BaseBloc.get<TeacherNotesBloc>(context).add(GetNotesEvent());
          } else if (state is DoneGetNotesState) {
            notes = state.notes;
          } else if (state is DoneDownloadTeacherState) {
            OpenFilex.open(state.entity.savePath!);
          }
          return Padding(
            padding: const EdgeInsets.only(top: 0),
            child: SafeArea(
              child: Scaffold(
                bottomNavigationBar: BottomNavigatorBar(items: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final tempDir = await getTemporaryDirectory();

                        // Define a file path for the downloaded file
                        final filePath = '${tempDir.path}/teachers.pdf';
                        BaseBloc.get<TeacherNotesBloc>(context).add(
                            DownloadTeacherPdfEvent(
                                paginationEntity: entity..savePath = filePath));
                      },
                      child: Text(
                        '${'export'.tr()} PDF',
                        style: AbhayaLibreSemiBold.copyWith(
                            color: Colors.black,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        AwesomeDialog(
                                dialogType: DialogType.noHeader,
                                context: context,
                                body: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    DateWidget(
                                      selectDate: selectDate,
                                      onChange: (value) {
                                        setState(() {
                                          Navigator.pop(context);
                                          Navigator.pop(context);

                                          selectDate =
                                              '${value.hijriDate} ${value.hijriDate2}';

                                          entity.startDate =
                                              AppUtils.convertToWesternNumerals(
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(
                                                          value.gregorianDate));
                                          entity.endDate =
                                              AppUtils.convertToWesternNumerals(
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(value
                                                          .gregorianDate2!));
                                          _pagingController.refresh();
                                        });
                                      },
                                      isRange: true,
                                    ),
                                    Titile(
                                      label: 'choose_teachers'.tr(),
                                    ),
                                    SelectInput(
                                      selectedValue: selected,
                                      items: teachers,
                                      onChanged: (value) {
                                        setState(() {
                                          Navigator.pop(context);
                                          selected = value;
                                          entity.teacher = value!.id.toString();
                                          entity.page = 1;
                                          _pagingController.refresh();
                                        });
                                      },
                                      label: 'choose_teachers'.tr(),
                                    ),
                                    Titile(
                                      label: 'choose_note'.tr(),
                                    ),
                                    SelectInput(
                                      selectedValue: selected2,
                                      items: notes,
                                      onChanged: (value) {
                                        setState(() {
                                          Navigator.pop(context);
                                          selected2 = value;
                                          entity.note = value!.id.toString();
                                          entity.page = 1;
                                          _pagingController.refresh();
                                        });
                                      },
                                      label: 'choose_note'.tr(),
                                    ),
                                  ],
                                ),
                                btnOkOnPress: () {
                                  setState(() {
                                    selected2 = null;
                                    selected = null;
                                    selectDate = 'start_end'.tr();
                                    entity.endDate = '';
                                    entity.note = '';
                                    entity.startDate = '';
                                    entity.teacher = '';
                                    entity.page = 1;
                                    _pagingController.refresh();
                                  });
                                },
                                btnOkText: 'delete'.tr())
                            .show();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        elevation: 4,
                      ),
                      child: Text(
                        ('filter').tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ]),
                body: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'notes'.tr(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.checkbox),
                        ),
                      ),
                      Expanded(
                        child: PagedListView<int, NotesTeacher>(
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            pagingController: _pagingController,
                            builderDelegate:
                                PagedChildBuilderDelegate<NotesTeacher>(
                                    noItemsFoundIndicatorBuilder: (context) =>
                                        Center(
                                          child: Image.asset(
                                              'assets/images/add.png'),
                                        ),
                                    itemBuilder: (context, item, index) {
                                      return ItemTeacherWidget(
                                        visitModel: item,
                                        pagingController: _pagingController,
                                      );
                                    })),
                      )
                    ],
                  ),
                ),
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
