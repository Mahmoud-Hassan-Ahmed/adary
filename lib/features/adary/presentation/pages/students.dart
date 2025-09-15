import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/class_room.dart';
import 'package:adary/features/adary/data/models/classes.dart';
import 'package:adary/features/adary/data/models/student_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_students_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/students/students_bloc.dart';
import 'package:adary/features/adary/presentation/pages/add_social.dart';
import 'package:adary/features/adary/presentation/widgets/social/item_student.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class Students extends StatefulWidget {
  const Students({super.key, required this.classId});
  final Classroom classId;

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  final PagingController<int, StudentModel> _pagingController =
      PagingController(firstPageKey: 1);
  late PaginationEntity entity;
  final getModel19useCase = sl<GetStudentsUseCase>();
  @override
  void initState() {
    entity = PaginationEntity(page: 1, classId: widget.classId.id);

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
      AppUtils.log(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<StudentsBloc>(),
      child: BlocBuilder<StudentsBloc, StudentsState>(
        builder: (context, state) {
          if (state is DoneDeleteStudentState) {
            AppUtils.showCustomSnackbar(
                'deleted_student'.tr(), SnackType.SUCESS);
            _pagingController.refresh();
          }
          return SafeArea(
            child: Scaffold(
              appBar: MyAppBar(title: widget.classId.name),
              body: PagedListView<int, StudentModel>(
                  padding: EdgeInsets.zero,
                  physics: const BouncingScrollPhysics(),
                  pagingController: _pagingController,
                  builderDelegate: PagedChildBuilderDelegate<StudentModel>(
                      noItemsFoundIndicatorBuilder: (context) => Center(
                            child: Image.asset('assets/images/add.png'),
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
