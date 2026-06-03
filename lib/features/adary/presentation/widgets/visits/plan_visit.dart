import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/evaluation_model.dart';
import 'package:adary/features/adary/presentation/bloc/evaluations/evaluations_bloc.dart';
import 'package:adary/features/adary/presentation/pages/class_visit.dart';
import 'package:adary/features/adary/presentation/pages/done_added_page.dart';
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
              AppUtils.go(DoneAddedPage(
                  label: 'updated_evaluation'.tr(),
                  title: 'visit_rating'.tr()));
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
                                    title: 'planning'.tr(),
                                    icon: 'assets/icons/rate1.svg',
                                  ),
                                  _buildTab(
                                    index: 1,
                                    controller: controller,
                                    title: 'implementation'.tr(),
                                    icon: 'assets/icons/rate2.svg',
                                  ),
                                  _buildTab(
                                    index: 2,
                                    controller: controller,
                                    title: 'class_management'.tr(),
                                    icon: 'assets/icons/rate3.svg',
                                  ),
                                  _buildTab(
                                    index: 2,
                                    controller: controller,
                                    title: 'class_interactions'.tr(),
                                    icon: 'assets/icons/rate4.svg',
                                  ),
                                  _buildTab(
                                    index: 2,
                                    controller: controller,
                                    title: 'results_and_recommendations'.tr(),
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
                                label1: 'clarity_lesson_objectives'.tr(),
                                start1: visit.planning?.clarityLesson ?? 0,
                                label2: 'lesson_content_time_appropriate'.tr(),
                                start2:
                                    visit.planning?.lessonContentAppropriate ??
                                        0,
                                label3:
                                    'use_appropriate_teaching_materials'.tr(),
                                start3: visit.planning
                                        ?.appropriateEducationalMethods ??
                                    0,
                                note: visit.planning?.note ?? '',
                                label4: 'planning_notes'.tr(),
                                hint: 'planning_notes_hint'.tr(),
                              ),
                              RatingForm(
                                id: visit?.id ?? 0,
                                index: 1,
                                label1: 'clarity_explanation_presentation'.tr(),
                                start1:
                                    visit.implementation?.clarityExplanation ??
                                        0,
                                label2: 'variety_teaching_strategies'.tr(),
                                start2:
                                    visit.implementation?.diversityStrategies ??
                                        0,
                                label3: 'consider_individual_differences'.tr(),
                                start3: visit.implementation?.investTime ?? 0,
                                note: visit.implementation?.note ?? '',
                                label4: 'implementation_notes'.tr(),
                                hint: 'implementation_notes_hint'.tr(),
                              ),
                              RatingForm(
                                id: visit?.id ?? 0,
                                index: 2,
                                label1: 'control_student_behavior'.tr(),
                                start1: visit.managment
                                        ?.controllingStudentBehavior ??
                                    0,
                                label2: 'organizing_classroom'.tr(),
                                start2:
                                    visit.managment?.organizingClassroom ?? 0,
                                label3: 'effective_use_of_class_time'.tr(),
                                start3: visit.managment?.investClassTime ?? 0,
                                note: visit.managment?.note ?? '',
                                label4: 'management_notes'.tr(),
                                hint: 'management_notes_hint'.tr(),
                              ),
                              RatingForm(
                                id: visit?.id ?? 0,
                                index: 3,
                                label1:
                                    'student_interaction_participation'.tr(),
                                start1:
                                    visit.interaction?.studentInteraction ?? 0,
                                label2: 'use_varied_assessment_methods'.tr(),
                                start2:
                                    visit.interaction?.variousEvaluation ?? 0,
                                label3: 'provide_feedback_to_students'.tr(),
                                start3: visit.interaction?.provideFeed ?? 0,
                                note: visit.interaction?.note ?? '',
                                label4: 'interaction_notes'.tr(),
                                hint: 'interaction_notes_hint'.tr(),
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
