import 'dart:convert';

import 'package:adary/core/conts/api.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/custom_text_field.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// نموذج «اتصل بنا». يرسل إلى `dashboard-mobile/contact-us/` الذي يشترط
/// عنوانا ورسالة بثلاثة أحرف على الأقل لكل منهما.
class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _title = TextEditingController();
  final _message = TextEditingController();
  bool _isSending = false;

  @override
  void dispose() {
    _title.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_title.text.trim().length < 3 || _message.text.trim().length < 3) {
      AppUtils.showCustomSnackbar(
          'contact_us_too_short'.tr(), SnackType.FAILURE);
      return;
    }

    setState(() => _isSending = true);
    try {
      final user = AppUtils.appUser!;
      final response = await http.post(
        Uri.parse('${Api.baseUrl}dashboard-mobile/contact-us/'),
        headers: {
          'username': user.username,
          'app-key': user.ky,
          'Accept-Language': 'ar',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {'title': _title.text.trim(), 'message': _message.text.trim()}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['success'] == true) {
        _title.clear();
        _message.clear();
        AppUtils.showCustomSnackbar(
            data['msg']?.toString() ?? 'send_successfully'.tr(),
            SnackType.SUCESS);
      } else {
        AppUtils.showCustomSnackbar(
            data['msg']?.toString() ?? 'error_happened'.tr(),
            SnackType.FAILURE);
      }
    } catch (_) {
      AppUtils.showCustomSnackbar('error_happened'.tr(), SnackType.FAILURE);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: 'contact_us'.tr()),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 10),
              CustomTextField(
                hintText: 'titel'.tr(),
                controller: _title,
              ),
              const SizedBox(height: 15),
              CustomTextField(
                hintText: 'msg'.tr(),
                maxLines: 7,
                controller: _message,
              ),
              const SizedBox(height: 30),
              BtnApp(
                label: _isSending ? '...' : 'save'.tr(),
                onTap: _isSending ? () {} : _send,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
