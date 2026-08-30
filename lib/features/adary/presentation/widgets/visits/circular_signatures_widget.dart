import 'package:adary/core/conts/api.dart';
import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/features/adary/data/models/circular_model.dart';
import 'package:adary/features/adary/data/models/circular_signature_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_circular_signatures_use_case.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// شاشة «التوقيعات»: اسم كل معلم وصورة توقيعه المحفوظة على تعميم بعينه.
///
/// المعلم يرفع صورة توقيعه مرة واحدة من تطبيقه، ثم يوقّع التعميم فيصله هنا
/// موقّعًا. غير الموقّعين يظهرون بلا صورة مع حالتهم (اطّلع / لم يوقّع).
class CircularSignaturesWidget extends StatefulWidget {
  const CircularSignaturesWidget({super.key, required this.circular});
  final AdministrativeCircular circular;

  @override
  State<CircularSignaturesWidget> createState() =>
      _CircularSignaturesWidgetState();
}

class _CircularSignaturesWidgetState extends State<CircularSignaturesWidget> {
  final _useCase = sl<GetCircularSignaturesUseCase>();

  CircularSignatures? _data;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final result =
        await _useCase(PaginationEntity(page: 1, classId: widget.circular.id));

    if (!mounted) return;
    result.fold(
      (failure) => setState(() {
        _error = failure.message;
        _isLoading = false;
      }),
      (data) => setState(() {
        _data = data;
        _isLoading = false;
      }),
    );
  }

  /// الخادم قد يرد بمسار نسبي، فنبنيه كاملًا كما تفعل شاشة توقيع المدير.
  String? _absoluteUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return Api.baseUrl.endsWith('/')
        ? '${Api.baseUrl}${path.startsWith('/') ? path.substring(1) : path}'
        : '${Api.baseUrl}/$path';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: SafeArea(
        child: Scaffold(
          appBar: MyAppBar(title: 'signatures'.tr()),
          body: _buildBody(context),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            TextButton(onPressed: _load, child: Text('retry'.tr())),
          ],
        ),
      );
    }

    final data = _data;
    if (data == null || data.teachers.isEmpty) {
      return Center(child: Image.asset('assets/images/add.png'));
    }

    return Column(
      children: [
        _Summary(signed: data.signedCount, total: data.totalCount),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _load,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: data.teachers.length,
              separatorBuilder: (_, __) => const Divider(
                height: 5,
                indent: 20,
                endIndent: 20,
                color: AppColors.BORDERGREYCOLOR,
              ),
              itemBuilder: (context, index) => _SignatureTile(
                teacher: data.teachers[index],
                imageUrl: _absoluteUrl(data.teachers[index].signatureUrl),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Summary extends StatelessWidget {
  const _Summary({required this.signed, required this.total});
  final int signed;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.APP_COLOR),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'signatures_count'.tr(),
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(width: 8),
          Text(
            '$signed / $total',
            style: Theme.of(context).textTheme.labelMedium!.copyWith(
                  color: AppColors.APP_COLOR,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }
}

class _SignatureTile extends StatelessWidget {
  const _SignatureTile({required this.teacher, required this.imageUrl});
  final TeacherSignature teacher;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        teacher.teacherName,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      subtitle: Text(
        teacher.isSigned
            ? 'signed'.tr()
            : (teacher.isViewed ? 'viewed'.tr() : 'no_signed'.tr()),
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: teacher.isSigned ? AppColors.APP_COLOR : Colors.grey,
            ),
      ),
      leading: Icon(
        teacher.isSigned
            ? Icons.check_circle
            : (teacher.isViewed
                ? Icons.remove_red_eye_outlined
                : Icons.visibility_off),
        color: teacher.isSigned ? AppColors.APP_COLOR : Colors.grey,
      ),
      // التوقيع صورة يرفعها المعلم بأبعاد غير موحّدة، فنحصر مساحتها هنا.
      trailing: teacher.isSigned && imageUrl != null
          ? SizedBox(
              width: 90,
              height: 45,
              child: CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.contain,
                placeholder: (context, url) => const Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Text(
                  'no_signature_image'.tr(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            )
          : (teacher.isSigned
              ? Text(
                  'no_signature_image'.tr(),
                  style: Theme.of(context).textTheme.labelSmall,
                )
              : null),
      onTap: teacher.isSigned && imageUrl != null
          ? () => _showFullSignature(context, imageUrl!)
          : null,
    );
  }

  /// الخادم يرسل الوقت بصيغة ISO؛ نعرضه بتوقيت الجهاز.
  String _formatSignedAt(String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return DateFormat('yyyy-MM-dd  hh:mm a').format(parsed.toLocal());
  }

  void _showFullSignature(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                teacher.teacherName,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(height: 12),
              CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                errorWidget: (context, url, error) =>
                    Text('no_signature_image'.tr()),
              ),
              if (teacher.signedAt != null) ...[
                const SizedBox(height: 12),
                Text(
                  _formatSignedAt(teacher.signedAt!),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
