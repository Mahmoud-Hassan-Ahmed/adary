import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/app_text_styles.dart';
import 'package:adary/features/adary/data/models/wishes_model.dart';
import 'package:adary/features/adary/presentation/bloc/wishes/wishes_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// "رغبات <اسم المعلم>" — بطاقة لكل فصل ومعها المواد التي اختارها فيه.
///
/// عرض فقط: المدير يقرأ ما سجّله المعلم، والتعديل والحذف في تطبيق المعلم.
class TeacherWishesPage extends StatefulWidget {
  const TeacherWishesPage({super.key, required this.teacher});

  final WishTeacherModel teacher;

  @override
  State<TeacherWishesPage> createState() => _TeacherWishesPageState();
}

class _TeacherWishesPageState extends State<TeacherWishesPage> {
  TeacherWishesResponse? _data;
  bool _failed = false;
  late final WishesBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = sl<WishesBloc>()
      ..add(GetTeacherWishesEvent(teacherId: widget.teacher.id));
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
          if (state is GetTeacherWishesState) {
            setState(() {
              _data = state.data;
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
                  // اسم المعلم من الصف الذي فُتحت منه الشاشة، فيظهر العنوان
                  // كاملًا من اللحظة الأولى بدل أن يقفز بعد وصول الرد.
                  text: '${'wishes_of'.tr()} ${widget.teacher.name}',
                  fontSize: AppTextStyles.h3,
                  bold: true,
                  maxLines: 1,
                ),
              ),
              body: Column(
                children: [
                  if (state is WishesLoadingState)
                    const LinearProgressIndicator(minHeight: 2),
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: () async => _bloc.add(
                          GetTeacherWishesEvent(teacherId: widget.teacher.id)),
                      child: _body(),
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

  Widget _body() {
    if (_data == null) {
      return _failed
          ? _message('wishes_load_failed'.tr())
          : const Center(child: CircularProgressIndicator());
    }
    if (_data!.wishes.isEmpty) {
      return _message('no_data_to_show'.tr());
    }
    return ListView.separated(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      itemCount: _data!.wishes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 14),
      itemBuilder: (context, index) => _WishCard(wish: _data!.wishes[index]),
    );
  }

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

/// بطاقة رغبة: ترويسة فيروزية باسم الفصل وشارة عدد مواده، ثم المواد مسرودة.
class _WishCard extends StatelessWidget {
  const _WishCard({required this.wish});

  final WishModel wish;

  static const Color _headerColor = Color(0xFFBFE4E5);
  static const Color _bodyColor = Color(0xFFE3F2F2);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _bodyColor,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: _headerColor,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const Icon(Icons.meeting_room_outlined,
                    size: 20, color: AppColors.APP_COLOR),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    wish.classroomName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.secondaryBold
                        .copyWith(color: AppColors.triblethree),
                  ),
                ),
                const SizedBox(width: 8),
                _countBadge(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF7F7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final course in wish.courses)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Container(
                              width: 5,
                              height: 5,
                              decoration: const BoxDecoration(
                                color: AppColors.APP_COLOR,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              course.name,
                              style: AppTextStyles.captionText
                                  .copyWith(color: AppColors.triblethree),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// عدد مواد هذا الفصل — "٢ رغبة" في التصميم.
  Widget _countBadge() => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFFDE7D8),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          '${wish.coursesCount} ${'one_wish_unit'.tr()}',
          style: AppTextStyles.tinyText.copyWith(
            color: const Color(0xFFE08B4C),
            fontWeight: FontWeight.w700,
          ),
        ),
      );
}
