import 'dart:convert';

import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

/// اتفاقية المستخدم. المحتوى مرفق مع التطبيق في
/// `assets/appData/privacy_policy.json` على هيئة أزواج: مفتاح عنوان يليه
/// مفتاح ينتهي بـ `_txt` يحمل نصه، فنعرضه بالترتيب دون افتراض أسماء بعينها
/// (فبعض الأقسام تخالف النمط مثل `communication` / `com_txt`).
class TermsConditions extends StatefulWidget {
  const TermsConditions({super.key});

  @override
  State<TermsConditions> createState() => _TermsConditionsState();
}

class _TermsConditionsState extends State<TermsConditions> {
  late final Future<List<_Section>> _sections;
  String _title = '';

  @override
  void initState() {
    super.initState();
    _sections = _load();
  }

  Future<List<_Section>> _load() async {
    final raw = await rootBundle.loadString('assets/appData/privacy_policy.json');
    final Map<String, dynamic> data = jsonDecode(raw);

    final sections = <_Section>[];
    String? pendingHeader;

    data.forEach((key, value) {
      final text = value?.toString() ?? '';
      if (text.isEmpty) return;

      if (key == 'header_txt') {
        _title = text;
        return;
      }

      if (key.endsWith('_txt')) {
        sections.add(_Section(pendingHeader, text));
        pendingHeader = null;
      } else {
        pendingHeader = text;
      }
    });

    return sections;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: 'terms_conditions_title'.tr()),
        body: FutureBuilder<List<_Section>>(
          future: _sections,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || snapshot.data == null) {
              return Center(child: Text('error_happened'.tr()));
            }

            return ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              physics: const BouncingScrollPhysics(),
              children: [
                if (_title.isNotEmpty) ...[
                  Text(
                    _title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.APP_COLOR,
                        ),
                  ),
                  const SizedBox(height: 20),
                ],
                for (final section in snapshot.data!) ...[
                  if (section.header != null) ...[
                    Text(
                      section.header!,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.APP_COLOR,
                          ),
                    ),
                    const SizedBox(height: 6),
                  ],
                  Text(
                    section.body,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(height: 1.7, color: Colors.black87),
                  ),
                  const SizedBox(height: 18),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Section {
  const _Section(this.header, this.body);
  final String? header;
  final String body;
}
