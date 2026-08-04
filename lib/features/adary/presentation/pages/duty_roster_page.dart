import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/app_text_styles.dart';
import 'package:adary/core/model/select_model.dart';
import 'package:adary/core/share/inputs/select_input.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/features/adary/data/models/duty_model.dart';
import 'package:adary/features/adary/presentation/bloc/duty/duty_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// المناوبة والإشراف — عرض فقط.
///
/// حلّت هذه الشاشة محل "المهام" في التطبيق. تعرض جداول المعلمين كما اعتمدتها
/// المدرسة في لوحة الويب، مع فلتر بالمعلم. لا إضافة ولا تعديل ولا حذف هنا
/// قصدًا: توزيع المناوبات وتعديلها والتحضير عليها كلها من لوحة المدرسة.
class DutyRosterPage extends StatefulWidget {
  const DutyRosterPage({super.key});

  @override
  State<DutyRosterPage> createState() => _DutyRosterPageState();
}

class _DutyRosterPageState extends State<DutyRosterPage> {
  /// خيار "كل المعلمين" في الفلتر — `id = 0` لأن معرّفات المعلمين تبدأ من 1.
  static const int _allTeachersId = 0;

  /// آخر نتيجة ناجحة. تُحتفظ هنا لا في الحالة وحدها حتى تبقى قائمة الفلتر
  /// معروضة أثناء تحميل نتيجة معلم آخر بدل أن تختفي ثم تعود.
  DutyScheduleResponse? _data;
  int? _selectedTeacherId;
  bool _failed = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<DutyBloc>()..add(const GetDutyScheduleEvent(teacherId: null)),
      child: BlocConsumer<DutyBloc, DutyState>(
        listener: (context, state) {
          if (state is GetDutyScheduleState) {
            setState(() {
              _data = state.data;
              _failed = false;
            });
          } else if (state is DutyFailureState) {
            setState(() => _failed = true);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              appBar: MyAppBar(title: 'duty_supervision'.tr()),
              body: Column(
                children: [
                  _filterBar(context),
                  if (state is DutyLoadingState)
                    const LinearProgressIndicator(minHeight: 2),
                  if (_data?.plan != null) _planHeader(_data!.plan!),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async => _load(context, _selectedTeacherId),
                      child: _body(state),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _load(BuildContext context, int? teacherId) {
    setState(() => _selectedTeacherId = teacherId);
    BaseBloc.get<DutyBloc>(context)
        .add(GetDutyScheduleEvent(teacherId: teacherId));
  }

  Widget _body(DutyState state) {
    if (_data == null) {
      // تفاصيل الخطأ نفسها يعرضها اعتراض dio في رسالة منبثقة.
      return _failed
          ? _message('duty_load_failed'.tr())
          : const Center(child: CircularProgressIndicator());
    }
    if (_data!.results.isEmpty) {
      return _message('no_duties'.tr());
    }
    return ListView.builder(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 16),
      itemCount: _data!.results.length,
      itemBuilder: (context, index) =>
          _TeacherCard(schedule: _data!.results[index]),
    );
  }

  /// رسالة بملء الشاشة تبقى قابلة للسحب، حتى يعمل السحب للتحديث وهي فارغة.
  Widget _message(String text) => LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: constraints.maxHeight,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: LabelMainText(
                  text: text,
                  color: AppColors.GREYFONTCOLOR,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _filterBar(BuildContext context) {
    final options = <SelectModel>[
      DutyTeacherOption(id: _allTeachersId, name: 'all_teachers'.tr()),
      ...?_data?.teachers,
    ];
    final selected = options.firstWhere(
      (o) => o.id == (_selectedTeacherId ?? _allTeachersId),
      orElse: () => options.first,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: SelectInput(
        items: options,
        selectedValue: selected,
        label: 'filter_by_teacher'.tr(),
        icon: const Icon(Icons.person_outline, color: AppColors.APP_COLOR),
        onChanged: (value) {
          if (value == null) return;
          _load(context, value.id == _allTeachersId ? null : value.id);
        },
      ),
    );
  }

  Widget _planHeader(DutyPlanInfo plan) {
    final period =
        plan.periodLabel.isNotEmpty ? plan.periodLabel : plan.hijriLabel;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              period.isEmpty ? plan.title : '${plan.title} — $period',
              style: AppTextStyles.captionText
                  .copyWith(color: AppColors.GREYFONTCOLOR),
            ),
          ),
        ],
      ),
    );
  }
}

/// بطاقة معلم واحد: اسمه ثم أيامه.
class _TeacherCard extends StatelessWidget {
  const _TeacherCard({required this.schedule});

  final DutyTeacherSchedule schedule;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: LabelMainText(
                    text: schedule.name,
                    fontSize: AppTextStyles.subtitle1,
                    bold: true,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.APP_COLOR.withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'duties_count'.tr(args: [schedule.dutyCount.toString()]),
                    style: AppTextStyles.captionText
                        .copyWith(color: AppColors.APP_COLOR),
                  ),
                ),
              ],
            ),
            const Divider(height: 18),
            ...schedule.days.map((day) => _DayRow(day: day)),
          ],
        ),
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  const _DayRow({required this.day});

  final DutyDay day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day.date == null
                ? day.weekdayLabel
                : '${day.weekdayLabel} — ${day.date}',
            style: AppTextStyles.secondaryBold
                .copyWith(color: AppColors.SECONDERYCOLOR),
          ),
          const SizedBox(height: 6),
          ...day.duties.map((duty) => _DutyTile(duty: duty)),
        ],
      ),
    );
  }
}

class _DutyTile extends StatelessWidget {
  const _DutyTile({required this.duty});

  final DutyItem duty;

  @override
  Widget build(BuildContext context) {
    // لون مختلف للإشراف عن المناوبة — الفئتان تكليفان مستقلان في النظام،
    // وتمييزهما بصريًا هو ما يجعل الجدول مقروءًا بنظرة واحدة.
    final color = duty.isSupervision ? AppColors.checkbox : AppColors.APP_COLOR;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (duty.icon.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(duty.icon, style: AppTextStyles.bodyText),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  duty.name,
                  style: AppTextStyles.listTitle.copyWith(color: color),
                ),
                Text(
                  duty.fullLabel,
                  style: AppTextStyles.captionText
                      .copyWith(color: AppColors.GREYFONTCOLOR),
                ),
                if (duty.locations.isNotEmpty)
                  Text(
                    duty.locationsLabel,
                    style: AppTextStyles.captionText
                        .copyWith(color: AppColors.GREYFONTCOLOR),
                  ),
              ],
            ),
          ),
          Text(
            '${duty.startTime} - ${duty.endTime}',
            style: AppTextStyles.captionText
                .copyWith(color: AppColors.SECONDERYCOLOR),
          ),
        ],
      ),
    );
  }
}
