import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/evaluation_model.dart';
import 'package:adary/features/adary/presentation/bloc/evaluations/evaluations_bloc.dart';
import 'package:adary/features/adary/presentation/pages/class_visit.dart';
import 'package:adary/features/adary/presentation/pages/done_added_page.dart';
import 'package:adary/features/adary/presentation/widgets/task/add_task_teacher.dart';
import 'package:adary/features/adary/presentation/widgets/task/current.dart';
import 'package:adary/features/adary/presentation/widgets/task/finsh.dart';
import 'package:adary/features/adary/presentation/widgets/task/next.dart';
import 'package:adary/features/adary/presentation/widgets/visits/evaliation_form.dart';
import 'package:adary/features/adary/presentation/widgets/visits/rate.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class RatingPage extends StatelessWidget {
  const RatingPage({super.key, required this.visit});
  final EvaluationModel visit;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EvaluationsBloc>(),
      child: BlocBuilder<EvaluationsBloc, EvaluationsState>(
        builder: (context, state) {
          if (state is DoneUpdatePlanningEvaluationState ||
              state is DoneUpdateInteractionEvaluationState ||
              state is DoneUpdateManagementEvaluationState ||
              state is DoneUpdateImplementationEvaluationState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              AppUtils.go(const DoneAddedPage(
                  label: 'تم تحديث التقييم بنجاح', title: 'تقيم الزيارة'));
            });
          }
          return DefaultTabController(
            length: 5,
            child: Builder(
              builder: (context) {
                final controller = DefaultTabController.of(context)!;

                return SafeArea(
                  child: Scaffold(
                    appBar: AppBar(
                      centerTitle: true,
                      iconTheme:
                          const IconThemeData(color: AppColors.APP_COLOR),
                      actions: [
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return const AddClassVisit(
                                    // pagingController: _pagingController,
                                    );
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
                      ],
                      title: Text(
                        'dialy_missions'.tr(),
                        style: AbhayaLibre.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.APP_COLOR,
                        ),
                      ),
                    ),
                    body: Column(
                      children: [
                        /// 🔹 TabBar
                        Container(
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: AppColors.APP_COLOR),
                          ),
                          child: AnimatedBuilder(
                            animation: controller,
                            builder: (context, _) {
                              return TabBar(
                                isScrollable: true,
                                indicator: BoxDecoration(
                                  color: AppColors.APP_COLOR,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                labelColor: Colors.white,
                                unselectedLabelColor: AppColors.APP_COLOR,
                                indicatorSize: TabBarIndicatorSize.tab,
                                dividerColor: Colors.transparent,
                                splashFactory: NoSplash.splashFactory,
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                tabs: [
                                  _buildTab(
                                    index: 0,
                                    controller: controller,
                                    title: 'التخطيط والإعداد',
                                    icon: 'assets/icons/rate1.svg',
                                  ),
                                  _buildTab(
                                    index: 1,
                                    controller: controller,
                                    title: 'التنفيذ والتدريس'.tr(),
                                    icon: 'assets/icons/rate2.svg',
                                  ),
                                  _buildTab(
                                    index: 2,
                                    controller: controller,
                                    title: 'إدارة الفصل'.tr(),
                                    icon: 'assets/icons/rate3.svg',
                                  ),
                                  _buildTab(
                                    index: 2,
                                    controller: controller,
                                    title: 'التفاعل والتقييم'.tr(),
                                    icon: 'assets/icons/rate4.svg',
                                  ),
                                  _buildTab(
                                    index: 2,
                                    controller: controller,
                                    title: 'النتائج والتوصيات'.tr(),
                                    icon: 'assets/icons/rate5.svg',
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                        /// 🔹 المحتوى
                        Expanded(
                          child: TabBarView(
                            children: [
                              RatingForm(
                                id: visit?.id ?? 0,
                                index: 0,
                                label1: "وضوح أهداف الدرس",
                                start1: visit.planning?.clarityLesson ?? 0,
                                label2: "ملاءمة محتوى الدرس للوقت المخصص",
                                start2:
                                    visit.planning?.lessonContentAppropriate ??
                                        0,
                                label3: "استخدام مواد تعليمية مناسبة",
                                start3: visit.planning
                                        ?.appropriateEducationalMethods ??
                                    0,
                                note: visit.planning?.note ?? '',
                                label4: "ملاحظات حول التخطيط والإعداد",
                                hint: "ادخل ملاحظاتك حول التخطيط والإعداد",
                              ),
                              RatingForm(
                                id: visit?.id ?? 0,
                                index: 1,
                                label1: "وضوح الشرح وأسلوب العرض",
                                start1:
                                    visit.implementation?.clarityExplanation ??
                                        0,
                                label2: "تنويع استراتيجيات التدريس",
                                start2:
                                    visit.implementation?.diversityStrategies ??
                                        0,
                                label3: "مراعاة الفروق الفردية بين الطلاب ",
                                start3: visit.implementation?.investTime ?? 0,
                                note: visit.implementation?.note ?? '',
                                label4: "ملاحظات حول التنفيذ والتدريس",
                                hint: "ادخل ملاحظاتك حول التنفيذ والتدريس",
                              ),
                              RatingForm(
                                id: visit?.id ?? 0,
                                index: 2,
                                label1: "التحكم في سلوك الطلاب والانضباط ",
                                start1: visit.managment
                                        ?.controllingStudentBehavior ??
                                    0,
                                label2: "تنظيم الفصل الدراسي",
                                start2:
                                    visit.managment?.organizingClassroom ?? 0,
                                label3: "الاستفادة الفعالة من وقت الحصة",
                                start3: visit.managment?.investClassTime ?? 0,
                                note: visit.managment?.note ?? '',
                                label4: "ملاحظات حول إدارة الفصل",
                                hint: "ادخل ملاحظاتك حول إدارة الفصل",
                              ),
                              RatingForm(
                                id: visit?.id ?? 0,
                                index: 3,
                                label1: "تفاعل الطلاب ومشاركتهم",
                                start1:
                                    visit.interaction?.studentInteraction ?? 0,
                                label2: "استخدام أساليب تقييم متنوعة",
                                start2:
                                    visit.interaction?.variousEvaluation ?? 0,
                                label3: "توفير التغذية الراجعة للطلاب",
                                start3: visit.interaction?.provideFeed ?? 0,
                                note: visit.interaction?.note ?? '',
                                label4: "ملاحظات حول التفاعل والتقييم",
                                hint: "ادخل ملاحظاتك حول التفاعل والتقييم",
                              ),
                              EvaluationPage(
                                visit: visit,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  /// 🔥 Widget التاب
  Widget _buildTab({
    required int index,
    required TabController controller,
    required String title,
    required String icon,
  }) {
    final bool isSelected = controller.index == index;

    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            icon,
            width: 20,
            height: 20,
            color: isSelected ? Colors.white : AppColors.APP_COLOR,
          ),
          const SizedBox(width: 8),
          Text(title),
        ],
      ),
    );
  }
}
