import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/errors/failure.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/share/widgets/radio_btn.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/procedure_cycle.dart';
import 'package:adary/features/adary/domain/entities/manager_decision_entity.dart';
// `dartz` يصدّر اسم State أيضًا فيتعارض مع State الخاص بـ Flutter.
import 'package:dartz/dartz.dart' hide State;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// دالة حفظ القرار — تختلف بين نموذج ١٨ ونموذج ٢٠، فتُمرَّر من شاشة القائمة
/// حتى تخدم هذه الشاشة النموذجين بلا أن تعرف أيهما.
typedef DecisionSubmitter = Future<Either<Failure, void>> Function(
    ManagerDecisionEntity entity);

/// شاشة "رأي مدير المدرسة": يقرأ المدير سبب المعلّم، يعتمد رأيه من خيارات
/// النموذج، ثم يقرر إن كان المعلّم سيُشعَر بالقرار وعبر أي قناة.
class ManagerDecisionPage extends StatefulWidget {
  const ManagerDecisionPage({
    super.key,
    required this.procedureId,
    required this.cycle,
    required this.onSubmit,
    this.showManagerNote = false,
    this.initialManagerNote,
  });

  final int procedureId;
  final ProcedureCycle cycle;
  final DecisionSubmitter onSubmit;

  /// مساءلة الملاحظة وحدها تسمح للمدير بكتابة تعليق على إفادة المعلّم؛
  /// النماذج الأخرى لا تملك الحقل فتُخفى الخانة عندها.
  final bool showManagerNote;
  final String? initialManagerNote;

  @override
  State<ManagerDecisionPage> createState() => _ManagerDecisionPageState();
}

class _ManagerDecisionPageState extends State<ManagerDecisionPage> {
  String? _decision;
  final TextEditingController _managerNote = TextEditingController();
  bool _notifyTeacher = false;
  bool _notifyApp = false;
  bool _notifyWhatsapp = false;
  bool _notifySms = false;

  @override
  void initState() {
    super.initState();
    // فتح الشاشة على قرار سابق يجعل التعديل عليه ممكنًا دون إعادة إدخاله.
    _decision = widget.cycle.managerDecision;
    _managerNote.text = widget.initialManagerNote ?? '';
    _notifyTeacher = widget.cycle.notifyTeacher;
    _notifyApp = widget.cycle.notifyApp;
    _notifyWhatsapp = widget.cycle.notifyWhatsapp;
    _notifySms = widget.cycle.notifySms;
  }

  Future<void> _save() async {
    if (_decision == null) {
      AppUtils.showCustomSnackbar('choose_decision'.tr(), SnackType.FAILURE);
      return;
    }
    if (_notifyTeacher && !_notifyApp && !_notifyWhatsapp && !_notifySms) {
      AppUtils.showCustomSnackbar(
          'choose_notify_channel'.tr(), SnackType.FAILURE);
      return;
    }

    final result = await widget.onSubmit(ManagerDecisionEntity(
      id: widget.procedureId,
      decision: _decision!,
      managerNote: widget.showManagerNote ? _managerNote.text.trim() : null,
      notifyTeacher: _notifyTeacher,
      notifyApp: _notifyApp,
      notifyWhatsapp: _notifyWhatsapp,
      notifySms: _notifySms,
    ));

    if (!mounted) return;
    result.fold(
      (failure) => null, // رسالة الخطأ تخرج من اعتراض Dio أصلًا.
      (_) {
        AppUtils.showCustomSnackbar('decision_saved'.tr(), SnackType.SUCESS);
        Navigator.pop(context, true);
      },
    );
  }

  /// قناة إشعار واحدة، تابعة لخيار "إرسال إشعار للمعلم" فوقها: بلا إشعار لا
  /// معنى لاختيار قناته، والخادم يصفّرها حينئذٍ على أي حال.
  ///
  /// تبقى ظاهرة وهي معطّلة كما في التصميم — إخفاؤها يجعل الشاشة تقفز عند كل
  /// ضغطة على الأب، وبقاؤها باهتة يُري المدير ما ينتظره إن فعّله.
  Widget _channel({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Opacity(
      opacity: _notifyTeacher ? 1 : 0.4,
      child: IgnorePointer(
        ignoring: !_notifyTeacher,
        child: RadioBtn(
          group: value ? 1 : 0,
          value: 1,
          label: label,
          valueChanged: (_) => setState(() => onChanged(!value)),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _managerNote.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: 'manager_opinion'.tr()),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: BtnApp(label: 'save_data'.tr(), onTap: _save),
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          physics: const BouncingScrollPhysics(),
          children: [
            _SectionCard(
              icon: 'assets/icons/hugeicons_chat-notification.svg',
              title: 'teacher_reason'.tr(),
              children: [
                Text(
                  widget.cycle.teacherReason?.trim().isNotEmpty == true
                      ? widget.cycle.teacherReason!
                      : 'teacher_reason_empty'.tr(),
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                        color: widget.cycle.teacherReason == null
                            ? AppColors.GREYFONTCOLOR
                            : AppColors.APP_COLOR,
                      ),
                ),
              ],
            ),
            if (widget.showManagerNote) ...[
              const SizedBox(height: 12),
              _SectionCard(
                icon: 'assets/icons/hugeicons_chat-notification.svg',
                title: 'manager_note'.tr(),
                children: [
                  TextField(
                    controller: _managerNote,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'manager_note_hint'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            _SectionCard(
              icon: 'assets/icons/mdi_arrow-decision-outline.svg',
              title: 'manager_decision'.tr(),
              children: [
                for (var i = 0; i < widget.cycle.decisionOptions.length; i++)
                  ...[
                    // فاصل بين الخيارات كما في التصميم — لا يسبق أولها.
                    if (i > 0)
                      const Divider(
                        height: 20,
                        thickness: 1,
                        color: Color(0xFFEDEDED),
                      ),
                    _DecisionTile(
                      option: widget.cycle.decisionOptions[i],
                      selected:
                          _decision == widget.cycle.decisionOptions[i].value,
                      onTap: () => setState(
                        () => _decision = widget.cycle.decisionOptions[i].value,
                      ),
                    ),
                  ],
              ],
            ),
            const SizedBox(height: 16),
            RadioBtn(
              group: _notifyTeacher ? 1 : 0,
              value: 1,
              label: 'notify_teacher'.tr(),
              valueChanged: (_) => setState(() {
                _notifyTeacher = !_notifyTeacher;
                // إطفاء الإشعار يطفئ قنواته معه حتى لا تُحفظ قناة بلا إشعار.
                if (!_notifyTeacher) {
                  _notifyApp = false;
                  _notifyWhatsapp = false;
                  _notifySms = false;
                }
              }),
            ),
            const SizedBox(height: 10),
            _channel(
              label: 'notify_by_app'.tr(),
              value: _notifyApp,
              onChanged: (v) => _notifyApp = v,
            ),
            const SizedBox(height: 10),
            _channel(
              label: 'notify_by_whatsapp'.tr(),
              value: _notifyWhatsapp,
              onChanged: (v) => _notifyWhatsapp = v,
            ),
            const SizedBox(height: 10),
            _channel(
              label: 'notify_by_sms'.tr(),
              value: _notifySms,
              onChanged: (v) => _notifySms = v,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.children,
  });

  final String icon;
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.APP_COLOR),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, height: 20, width: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: AppColors.APP_COLOR, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
}

/// خيار من خيارات رأي المدير. الخيار الذي يترتب عليه حسم يُؤطَّر بالأحمر
/// والقبول بالأخضر، ليقع الفرق بينهما تحت العين قبل الضغط لا بعده.
class _DecisionTile extends StatelessWidget {
  const _DecisionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  static const Color _accept = Color(0xFF4CAF50);
  static const Color _deduct = Color(0xFFF43F3F);

  final DecisionOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = option.isDeduction ? _deduct : _accept;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: color, width: selected ? 2 : 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              height: 22,
              width: 22,
              decoration: BoxDecoration(
                color: selected ? color : Colors.transparent,
                // المربّع الفارغ رماديّ لا بلون الخيار: اللون يدلّ على
                // المختار، فلو حمله الاثنان لم يعد يدلّ على شيء.
                border: Border.all(
                  color: selected ? color : AppColors.BORDERGREYCOLOR,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6),
              ),
              child: selected
                  ? const Icon(Icons.check, size: 15, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                option.label,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.black, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
