import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/note_accountability_model.dart';
import 'package:adary/features/adary/data/models/procedure_cycle.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_note_accountabilities_use_case.dart';
import 'package:adary/features/adary/domain/usecases/send_note_accountability_decision_use_case.dart';
import 'package:adary/features/adary/presentation/pages/manager_decision_page.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/// تبويب «مساءلات الملاحظات» بجانب نماذج ١٨ و١٩ و٢٠.
///
/// المساءلة تُنشأ من الموقع بالضغط على «إرسال مساءلة» أمام ملاحظة المعلّم،
/// فلا يوجد هنا زر إضافة: دور المدير في التطبيق هو قراءة إفادة المعلّم ثم
/// كتابة ملاحظته واعتماد رأيه.
class NoteAccountabilityPage extends StatefulWidget {
  const NoteAccountabilityPage({super.key});

  @override
  State<NoteAccountabilityPage> createState() => _NoteAccountabilityPageState();
}

class _NoteAccountabilityPageState extends State<NoteAccountabilityPage> {
  final PagingController<int, NoteAccountabilityModel> _pagingController =
      PagingController(firstPageKey: 1);
  final entity = PaginationEntity(page: 1);
  final _getUseCase = sl<GetNoteAccountabilitiesUseCase>();
  final _decisionUseCase = sl<SendNoteAccountabilityDecisionUseCase>();

  @override
  void initState() {
    _pagingController.addPageRequestListener(_fetchPage);
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    final result = await _getUseCase(entity..page = pageKey);
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

  Future<void> _openDecision(NoteAccountabilityModel item) async {
    // `Navigator.push` لا `AppUtils.go`: نحتاج نتيجة الشاشة لنعرف هل حُفظ
    // القرار فتُعاد القائمة، و`go` لا تُرجع شيئًا.
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => ManagerDecisionPage(
          procedureId: item.id,
          cycle: item.cycle,
          showManagerNote: true,
          initialManagerNote: item.managerNote,
          onSubmit: _decisionUseCase.call,
        ),
      ),
    );
    if (saved == true) _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => _pagingController.refresh(),
      child: PagedListView<int, NoteAccountabilityModel>(
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<NoteAccountabilityModel>(
          noItemsFoundIndicatorBuilder: (context) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'no_note_accountabilities'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ),
          ),
          itemBuilder: (context, item, index) => _AccountabilityCard(
            item: item,
            onDecision: () => _openDecision(item),
          ),
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

class _AccountabilityCard extends StatelessWidget {
  const _AccountabilityCard({required this.item, required this.onDecision});
  final NoteAccountabilityModel item;
  final VoidCallback onDecision;

  /// اللون يفرّق الحالات الثلاث بلمحة: بانتظار المعلّم، بانتظار قرار المدير،
  /// وقد صدر القرار. المدير يبحث عن الأوسط، فيميّزه اللون التحذيري.
  Color get _statusColor {
    switch (item.cycle.status) {
      case ProcedureCycle.statusDecided:
        return AppColors.APP_COLOR;
      case ProcedureCycle.statusPendingDecision:
        return const Color(0xFFF39C12);
      default:
        return AppColors.GREYFONTCOLOR;
    }
  }

  @override
  Widget build(BuildContext context) {
    final awaitingDecision =
        item.cycle.status == ProcedureCycle.statusPendingDecision;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.APP_COLOR),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.teacher.name,
            style: Theme.of(context)
                .textTheme
                .labelMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(item.noteText, style: Theme.of(context).textTheme.labelMedium),
          if (item.noteComment?.isNotEmpty == true) ...[
            const SizedBox(height: 4),
            Text(item.noteComment!,
                style: Theme.of(context).textTheme.labelSmall),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.event, size: 16, color: AppColors.GREYFONTCOLOR),
              const SizedBox(width: 4),
              Text(item.noteDateHijri ?? '—',
                  style: Theme.of(context).textTheme.labelSmall),
              if (item.noteSessionDisplay?.isNotEmpty == true) ...[
                const SizedBox(width: 12),
                const Icon(Icons.schedule,
                    size: 16, color: AppColors.GREYFONTCOLOR),
                const SizedBox(width: 4),
                Text(item.noteSessionDisplay!,
                    style: Theme.of(context).textTheme.labelSmall),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  item.cycle.status == ProcedureCycle.statusDecided
                      ? item.cycle.managerDecisionDisplay
                      : item.cycle.statusDisplay,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(color: _statusColor),
                ),
              ),
              TextButton(
                onPressed: onDecision,
                child: Text(
                  awaitingDecision
                      ? 'manager_opinion'.tr()
                      : 'show_details'.tr(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
