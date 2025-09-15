import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/circular_model.dart';
import 'package:adary/features/adary/data/models/teacher_circular.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_teachers_circular_use_case.dart';
import 'package:adary/features/adary/presentation/widgets/visits/Item_teacher_sign.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ListTeachersWidget extends StatefulWidget {
  const ListTeachersWidget({super.key, required this.classId});
  final AdministrativeCircular classId;

  @override
  State<ListTeachersWidget> createState() => _ListTeachersWidgetState();
}

class _ListTeachersWidgetState extends State<ListTeachersWidget> {
  final PagingController<int, TeacherCircular> _pagingController =
      PagingController(firstPageKey: 1);
  late PaginationEntity entity;

  final getModel20useCase = sl<GetTeachersCircularUseCase>();
  @override
  void initState() {
    entity = PaginationEntity(page: 1, classId: widget.classId.id);
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
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SafeArea(
        child: Scaffold(
          appBar: MyAppBar(title: widget.classId.title),
          body: PagedListView<int, TeacherCircular>(
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<TeacherCircular>(
                  noItemsFoundIndicatorBuilder: (context) => Center(
                        child: Image.asset('assets/images/add.png'),
                      ),
                  itemBuilder: (context, item, index) {
                    return ItemTeacherSign(
                      visitModel: item,
                    );
                  })),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
