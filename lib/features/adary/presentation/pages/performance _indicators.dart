import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/class_health.dart';
import 'package:adary/features/adary/data/models/evidence_model.dart';
import 'package:adary/features/adary/data/models/health_model.dart';
import 'package:adary/features/adary/domain/entities/evidence_entity.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_evidences_use_case.dart';
import 'package:adary/features/adary/domain/usecases/get_healths_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/evidence/evidence_bloc.dart';
import 'package:adary/features/adary/presentation/bloc/health/health_bloc.dart';
import 'package:adary/features/adary/presentation/pages/category_files.dart';
import 'package:adary/features/adary/presentation/widgets/note_teacher/titile.dart';
import 'package:adary/features/adary/presentation/widgets/performance/add_category.dart';
import 'package:adary/features/adary/presentation/widgets/performance/file_card.dart';
import 'package:adary/features/adary/presentation/widgets/performance/performance_item.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../core/bloc/base_bloc.dart';

class PerformanceIndicators extends StatefulWidget {
  const PerformanceIndicators({super.key});

  @override
  State<PerformanceIndicators> createState() => _PerformanceIndicatorsState();
}

class _PerformanceIndicatorsState extends State<PerformanceIndicators> {
  final PagingController<int, EvidenceTeacherModel> _pagingController =
      PagingController(firstPageKey: 1);
  late EvidencePaginationEntity entity;

  final getModel20useCase = sl<GetEvidencesUseCase>();
  @override
  void initState() {
    entity = EvidencePaginationEntity(school: AppUtils.appUser?.id ?? 1);
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  /// يتغيّر مع كل تغيير فلتر ليطَرح ردّ الطلب السابق.
  int _requestId = 0;

  Future<void> _fetchPage(int pageKey) async {
    final requestId = ++_requestId;
    final result = await getModel20useCase(entity.forPage(pageKey));
    // ردّ لفلتر قديم وصل بعد refresh — إلحاقه يخلط نتائج فلترين في الشبكة.
    if (!mounted || requestId != _requestId) return;
    result.fold(
      (failure) {
        // بلا هذا يبقى المؤشّر يلفّ إلى الأبد عند خطأ الخادم (500) بلا أي رسالة.
        _pagingController.error = failure;
        AppUtils.log(failure.toString());
      },
      (paginationModel) {
        // احتياط لو تجاهل الخادم `ordering` — الترتيب داخل الصفحة على الأقل.
        final items = paginationModel.results
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        if (paginationModel.next == null) {
          _pagingController.appendLastPage(items);
        } else {
          _pagingController.appendPage(items, pageKey + 1);
        }
      },
    );
  }

  int selectIndex = 0;
  List<SelectModel> teachers = [];
  List<SelectModel> categories = [];
  SelectModel? selectedTeacher;
  SelectModel? selectedCategory;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EvidenceBloc>(),
      child: BlocBuilder<EvidenceBloc, EvidenceState>(
        builder: (context, state) {
          if (state is EvidenceInitial) {
            BaseBloc.get<EvidenceBloc>(context)
                .add(const GetEvidencesCaregoriesEvent());
          } else if (state is DoneGetEvidencesCaregoriesState) {
            categories = state.model
                .map((e) => SessionModel(id: e.id ?? 0, name: e.name))
                .toList();
            BaseBloc.get<EvidenceBloc>(context).add(const GetTeachersEvent());
          } else if (state is DoneGetTeachersState) {
            teachers = state.model
                .map((e) => SessionModel(id: e.id ?? 0, name: e.name))
                .toList();
          } else if (state is SelectModelState) {
            if (state.type == 'teacher') {
              selectedTeacher = state.model;
              entity.teacher = state.model.id;
            } else if (state.type == 'category') {
              selectedCategory = state.model;
              entity.category = state.model.id;
            }
            // refresh() أثناء build يعيد بناء الشبكة وهي تُبنى، فيصل الردّ
            // القديم بعد الجديد ويظهر الخليط كأنّ العرض غير مرتّب.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _pagingController.refresh();
            });
          }
          return SafeArea(
            child: Scaffold(
              appBar: MyAppBar(
                  title: 'شواهد الاداء',
                  actions: selectIndex == 1
                      ? [
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  isScrollControlled: true,
                                  context: context,
                                  builder: (context) {
                                    return const AddCategory(
                                        // pagingController: _pagingController,
                                        );
                                  },
                                );
                              },
                              icon:
                                  SvgPicture.asset("assets/icons/icon-add.svg"))
                        ]
                      : []),
              bottomNavigationBar: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                              color: AppColors.APP_COLOR, width: 1.5),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectIndex = 0;
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/perform2 1.svg",
                                    width: 30,
                                    height: 30,
                                    color: selectIndex == 0
                                        ? AppColors.APP_COLOR
                                        : Colors.grey,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  LabelMainText(
                                    text: 'شواهد الاداء  ',
                                    fontSize: 14,
                                    color: selectIndex == 0
                                        ? AppColors.APP_COLOR
                                        : Colors.grey,
                                  )
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  selectIndex = 1;
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/grommet-icons_document-performance.svg",
                                    color: selectIndex == 1
                                        ? AppColors.APP_COLOR
                                        : Colors.grey,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  LabelMainText(
                                    text: 'فئات الاداء',
                                    fontSize: 14,
                                    color: selectIndex == 1
                                        ? AppColors.APP_COLOR
                                        : Colors.grey,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    IconButton(
                        padding: EdgeInsets.all(0),
                        onPressed: () {},
                        icon: SvgPicture.asset("assets/icons/icon-search.svg")),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(10),
                child: selectIndex == 0
                    ? Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Titile(
                                      label: ' أسم المعلم ',
                                    ),
                                    SelectInput(
                                        fontSize: 12,
                                        items: teachers,
                                        selectedValue: selectedTeacher,
                                        onChanged: (v) {
                                          BaseBloc.get<EvidenceBloc>(context)
                                              .emitState(SelectModelState(
                                                  model: v!, type: 'teacher'));
                                        },
                                        label: 'اختر  المعلم')
                                  ],
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Titile(
                                      label: 'اختر  الفئة ',
                                    ),
                                    SelectInput(
                                        items: categories,
                                        selectedValue: selectedCategory,
                                        onChanged: (v) {
                                          BaseBloc.get<EvidenceBloc>(context)
                                              .emitState(SelectModelState(
                                                  model: v!, type: 'category'));
                                        },
                                        label: 'اختر  الفئة')
                                  ],
                                ),
                              )
                            ],
                          ),
                          Expanded(
                            // child: PerformanceItem(),
                            child: PagedGridView<int, EvidenceTeacherModel>(
                                padding: const EdgeInsets.all(8),
                                physics: const BouncingScrollPhysics(),
                                pagingController: _pagingController,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // 👈 3 items per row
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                  childAspectRatio: 0.75,
                                ),
                                builderDelegate: PagedChildBuilderDelegate<
                                        EvidenceTeacherModel>(
                                    noItemsFoundIndicatorBuilder: (context) =>
                                        Center(
                                          child: Image.asset(
                                              'assets/images/add.png'),
                                        ),
                                    firstPageErrorIndicatorBuilder: (context) =>
                                        _ErrorRetry(
                                          onRetry: _pagingController.refresh,
                                        ),
                                    newPageErrorIndicatorBuilder: (context) =>
                                        _ErrorRetry(
                                          onRetry: _pagingController
                                              .retryLastFailedRequest,
                                        ),
                                    itemBuilder: (context, item, index) {
                                      return FileCard(
                                        model: item,
                                      );
                                    })),
                          ),
                        ],
                      )
                    : const CategoryFiles(),
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

/// رسالة خطأ الشبكة/الخادم مع إعادة المحاولة — بديل مؤشّر الحزمة الإنجليزي.
class _ErrorRetry extends StatelessWidget {
  const _ErrorRetry({required this.onRetry});
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'تعذّر تحميل شواهد الأداء',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onRetry,
            child: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
