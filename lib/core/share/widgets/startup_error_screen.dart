import 'package:flutter/material.dart';

/// بديل الشاشة البيضاء حين تفشل تهيئة التطبيق.
///
/// لا يعتمد على شيء من حَقن التبعيات ولا على الترجمة ولا على ScreenUtil —
/// فهو يُعرض تحديدًا حين تكون تلك كلها هي التي فشلت.
class StartupErrorScreen extends StatefulWidget {
  const StartupErrorScreen({
    super.key,
    required this.error,
    required this.onRetry,
  });

  final Object error;
  final Future<void> Function() onRetry;

  @override
  State<StartupErrorScreen> createState() => _StartupErrorScreenState();
}

class _StartupErrorScreenState extends State<StartupErrorScreen> {
  static const _appColor = Color.fromRGBO(60, 154, 166, 1);
  bool _retrying = false;

  Future<void> _retry() async {
    setState(() => _retrying = true);
    await widget.onRetry();
    // نجاح المحاولة يستبدل شجرة التطبيق كلها بـ runApp، فلا يعود هذا مركَّبًا.
    if (mounted) setState(() => _retrying = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.wifi_tethering_error_rounded,
                        size: 64, color: _appColor),
                    const SizedBox(height: 16),
                    const Text(
                      'تعذّر تشغيل التطبيق',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'تأكّد من اتصالك بالإنترنت ثم أعد المحاولة. إن تكرّر الأمر '
                      'فأرسل النص التالي للدعم الفني.',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 14, color: Color(0xFF707070)),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF6F3F3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SelectableText(
                        '${widget.error}',
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                            fontSize: 12, color: Color(0xFF5C5C5C)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _appColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _retrying ? null : _retry,
                      child: _retrying
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
