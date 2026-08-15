import 'dart:convert';
import 'dart:io';

import 'package:adary/core/conts/api.dart';
import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:signature/signature.dart';

/// شاشة توقيع مدير المدرسة: يرسمه بإصبعه أو يرفع صورة جاهزة، ويُحفظ على
/// المدرسة عبر `dashboard-mobile/manager-signature/`.
class ManagerSignature extends StatefulWidget {
  const ManagerSignature({super.key});

  @override
  State<ManagerSignature> createState() => _ManagerSignatureState();
}

class _ManagerSignatureState extends State<ManagerSignature> {
  late final SignatureController _controller;
  bool _isDrawingTab = true;
  bool _isBusy = false;
  bool _isLoading = true;
  File? _pickedFile;
  String? _signatureUrl;

  @override
  void initState() {
    super.initState();
    _controller = SignatureController(
      penStrokeWidth: 4,
      penColor: Colors.black,
      exportBackgroundColor: Colors.white,
    );
    _loadSignature();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Map<String, String> get _authHeaders {
    final user = AppUtils.appUser!;
    return {
      'username': user.username,
      'app-key': user.ky,
      'Accept-Language': 'ar',
    };
  }

  /// الخادم يرد بمسار نسبي، فنبني العنوان الكامل هنا كما تفعل صورة المدرسة.
  String? _absoluteUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith('http')) return path;
    return Api.baseUrl.endsWith('/')
        ? '${Api.baseUrl}${path.startsWith('/') ? path.substring(1) : path}'
        : '${Api.baseUrl}/$path';
  }

  Future<void> _loadSignature() async {
    try {
      final response = await http.get(
        Uri.parse('${Api.baseUrl}${Api.managerSignature}'),
        headers: _authHeaders,
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() =>
              _signatureUrl = _absoluteUrl(data['data']?['signature_url']));
        }
      }
    } catch (_) {
      // الشاشة تظل صالحة للرفع حتى لو تعذّر جلب التوقيع الحالي.
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(type: FileType.image);
      final picked = result?.files.firstOrNull;
      if (picked?.path != null && mounted) {
        setState(() => _pickedFile = File(picked!.path!));
      }
    } catch (_) {
      AppUtils.showCustomSnackbar('error_happened'.tr(), SnackType.FAILURE);
    }
  }

  Future<File?> _resolveFileToUpload() async {
    if (!_isDrawingTab) return _pickedFile;
    if (_controller.isEmpty) return null;

    final bytes = await _controller.toPngBytes();
    if (bytes == null) return null;
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/manager_signature.png');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> _save() async {
    final file = await _resolveFileToUpload();
    if (file == null) {
      AppUtils.showCustomSnackbar('draw_or_pick_signature'.tr(), SnackType.FAILURE);
      return;
    }

    setState(() => _isBusy = true);
    try {
      final request = http.MultipartRequest(
          'POST', Uri.parse('${Api.baseUrl}${Api.updateManagerSignature}'))
        ..headers.addAll(_authHeaders)
        ..files.add(await http.MultipartFile.fromPath('signature', file.path));

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(body);
        setState(() {
          _signatureUrl = _absoluteUrl(data['data']?['signature_url']);
          _pickedFile = null;
        });
        _controller.clear();
        AppUtils.showCustomSnackbar('signature_saved'.tr(), SnackType.SUCESS);
      } else {
        AppUtils.showCustomSnackbar('error_happened'.tr(), SnackType.FAILURE);
      }
    } catch (_) {
      AppUtils.showCustomSnackbar('error_happened'.tr(), SnackType.FAILURE);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _delete() async {
    setState(() => _isBusy = true);
    try {
      final response = await http.post(
        Uri.parse('${Api.baseUrl}${Api.deleteManagerSignature}'),
        headers: _authHeaders,
      );
      if (response.statusCode == 200) {
        setState(() => _signatureUrl = null);
        AppUtils.showCustomSnackbar('signature_deleted'.tr(), SnackType.SUCESS);
      } else {
        AppUtils.showCustomSnackbar('error_happened'.tr(), SnackType.FAILURE);
      }
    } catch (_) {
      AppUtils.showCustomSnackbar('error_happened'.tr(), SnackType.FAILURE);
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Widget _buildPreview() {
    if (_isLoading) {
      return const SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_signatureUrl == null) {
      return DottedBorder(
        color: Colors.grey,
        strokeWidth: 1.5,
        dashPattern: const [6, 4],
        borderType: BorderType.RRect,
        radius: const Radius.circular(12),
        child: SizedBox(
          height: 150,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.gesture_rounded, size: 40, color: Colors.grey),
              const SizedBox(height: 8),
              Text('no_signature_saved'.tr(),
                  style: const TextStyle(color: Colors.grey, fontSize: 14)),
            ],
          ),
        ),
      );
    }

    return Card(
      color: Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 120,
              width: double.infinity,
              child: CachedNetworkImage(
                imageUrl: _signatureUrl!,
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(
                    Icons.broken_image_outlined,
                    size: 40,
                    color: Colors.grey),
              ),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _isBusy ? null : _delete,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              label: Text('delete_signature'.tr(),
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tab(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
              color: active ? AppColors.APP_COLOR : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: 'manager_signature'.tr()),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16),
          child: BtnApp(
            label: _isBusy ? '...' : 'save'.tr(),
            onTap: _isBusy ? () {} : _save,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'signature_preview'.tr(),
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildPreview(),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _tab('sign_in_app'.tr(), _isDrawingTab,
                        () => setState(() => _isDrawingTab = true)),
                    _tab('pick_signature_image'.tr(), !_isDrawingTab,
                        () => setState(() => _isDrawingTab = false)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (_isDrawingTab) ...[
                Text('draw_signature_here'.tr(),
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Signature(
                    controller: _controller,
                    height: 220,
                    backgroundColor: Colors.grey.shade50,
                  ),
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton.icon(
                    onPressed: () => _controller.clear(),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: Text('clear_signature'.tr()),
                  ),
                ),
              ] else ...[
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 24, horizontal: 16),
                    child: Column(
                      children: [
                        if (_pickedFile != null) ...[
                          SizedBox(
                            height: 120,
                            child: Image.file(_pickedFile!,
                                fit: BoxFit.contain),
                          ),
                          const SizedBox(height: 16),
                        ],
                        OutlinedButton(
                          onPressed: _pickImage,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.APP_COLOR,
                            side: const BorderSide(color: AppColors.APP_COLOR),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text('choose_file'.tr()),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
