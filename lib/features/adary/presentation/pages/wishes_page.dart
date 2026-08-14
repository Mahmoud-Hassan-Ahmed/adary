import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/app_text_styles.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/pagination_model.dart';
import 'package:adary/features/adary/data/models/wishes_model.dart';
import 'package:adary/features/adary/presentation/bloc/wishes/wishes_bloc.dart';
import 'package:adary/features/adary/presentation/pages/teacher_wishes_page.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// "قائمة الرغبات" عند المدير — عرض فقط.
///
/// كل صف معلمٌ سجّل رغبات في تطبيق المعلم، ومعه عددها. المعلمون بلا رغبات
/// لا يظهرون: هذه قائمة رغبات لا دليل معلمين.
class WishesPage extends StatefulWidget {
  const WishesPage({super.key});

  @override
  State<WishesPage> createState() => _WishesPageState();
}

class _WishesPageState extends State<WishesPage> {
  /// آخر نتيجة ناجحة. تُحتفظ هنا لا في الحالة وحدها حتى تبقى القائمة
  /// معروضة أثناء تحميل صفحة أخرى بدل أن تختفي ثم تعود.
  PageinationModel<WishTeacherModel>? _data;
  bool _failed = false;
  late final WishesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<WishesBloc>()..add(const GetWishTeachersEvent());
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<WishesBloc, WishesState>(
        listener: (context, state) {
          if (state is GetWishTeachersState) {
            setState(() {
              _data = state.teachers;
              _failed = false;
            });
          } else if (state is WishesFailureState) {
            setState(() => _failed = true);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: const IconThemeData(color: AppColors.APP_COLOR),
                title: LabelMainText(
                  text: 'wishes'.tr(),
                  fontSize: AppTextStyles.h3,
                  bold: true,
                ),
              ),
              body: Column(
                children: [
                  if (state is WishesLoadingState)
                    const LinearProgressIndicator(minHeight: 2),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async =>
                          _bloc.add(const GetWishTeachersEvent()),
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

  Widget _body(WishesState state) {
    if (_data == null) {
      // تفاصيل الخطأ نفسها يعرضها اعتراض dio في رسالة منبثقة.
      return _failed
          ? _message('wishes_load_failed'.tr())
          : const Center(child: CircularProgressIndicator());
    }
    if (_data!.results.isEmpty) {
      return _message('no_data_to_show'.tr());
    }
    return ListView.separated(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: _data!.results.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _WishTeacherRow(
        teacher: _data!.results[index],
        order: index + 1,
        onTap: () => AppUtils.go(
          TeacherWishesPage(teacher: _data!.results[index]),
        ),
      ),
    );
  }

  /// رسالة بملء الشاشة تبقى قابلة للسحب، حتى يعمل السحب للتحديث وهي فارغة.
  Widget _message(String text) => LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: constraints.maxHeight,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDEEEE),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.info_outline,
                        color: Color(0xFFE05B5B), size: 38),
                  ),
                  const SizedBox(height: 16),
                  LabelMainText(
                    text: text,
                    color: AppColors.GREYFONTCOLOR,
                    fontSize: AppTextStyles.subtitle1,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

/// صف واحد: شارة الترتيب الملتصقة بحافة البطاقة، ثم حرف الاسم، ثم الاسم
/// وعدد الرغبات، ثم سهم الدخول.
class _WishTeacherRow extends StatelessWidget {
  const _WishTeacherRow({
    required this.teacher,
    required this.order,
    required this.onTap,
  });

  final WishTeacherModel teacher;
  final int order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // شارة الترتيب تمتدّ بارتفاع البطاقة، والبطاقة هي من يحدّد هذا الارتفاع،
    // فداخل قائمة الارتفاع غير محدود و stretch وحده يعطي الشارة ارتفاعًا لانهائيًا.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // شارة الترتيب في جهة البداية (اليمين في العربية) كما في التصميم.
          Container(
            width: 34,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.APP_COLOR,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(10),
              ),
            ),
            child: Text(
              '$order',
              style: AppTextStyles.secondaryBold.copyWith(color: Colors.white),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(10),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 12),
                    child: Row(
                      children: [
                        _avatar(),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                teacher.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.listTitle
                                    .copyWith(color: AppColors.triblethree),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _wishesLabel(),
                                style: AppTextStyles.captionText
                                    .copyWith(color: AppColors.GREYFONTCOLOR),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_ios,
                            size: 14, color: AppColors.GREYFONTCOLOR),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// "٣ رغبات" — والعربية تفرد وتثني قبل الجمع، فالنص يتبع العدد.
  String _wishesLabel() {
    final count = teacher.wishesCount;
    if (count == 1) return 'one_wish'.tr();
    if (count == 2) return 'two_wishes'.tr();
    return '$count ${'wishes_plural'.tr()}';
  }

  Widget _avatar() {
    final photo = teacher.photo;
    if (photo != null && photo.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          photo,
          width: 34,
          height: 34,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _initialBox(),
        ),
      );
    }
    return _initialBox();
  }

  Widget _initialBox() => Container(
        width: 34,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFFDE7D8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          teacher.initial,
          style: AppTextStyles.secondaryBold
              .copyWith(color: const Color(0xFFE08B4C)),
        ),
      );
}
