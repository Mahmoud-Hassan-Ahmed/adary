import 'dart:convert';
import 'dart:io';

import 'package:adary/core/conts/api.dart';
import 'package:adary/core/conts/images.dart';
import 'package:adary/core/conts/app_text_styles.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/widgets/btn_app.dart';
import 'package:adary/core/share/widgets/choose_lang.dart';
import 'package:adary/core/share/widgets/my_app_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/user_app.dart';
import 'package:adary/features/adary/presentation/pages/login_screen.dart';
import 'package:adary/features/adary/presentation/widgets/profiles/contact_us.dart';
import 'package:adary/features/adary/presentation/widgets/profiles/manager_signature.dart';
import 'package:adary/features/adary/presentation/widgets/profiles/subscription_manager.dart';
import 'package:adary/features/adary/presentation/widgets/profiles/terms_conditions.dart';
import 'package:adary/core/conts/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:adary/features/adary/presentation/widgets/notifications_diagnostics_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  bool _isUploading = false;
  String? _logoUrl;

  @override
  void initState() {
    super.initState();
    _logoUrl = AppUtils.appUser?.logo;
  }

  /// صف واحد في قائمة حسابي: أيقونة بلون التطبيق، ثم العنوان، ثم سهم في
  /// نهاية السطر — بنفس تنسيق تطبيق المعلم.
  Widget _customBox(
      {bool hasArrow = true,
      required String text,
      double fontSize = 16,
      FontWeight fwight = FontWeight.w600,
      Color fColor = const Color(0xFF2E2E2E),
      String? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                if (icon != null)
                  SvgPicture.asset(
                    icon,
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(fColor == Colors.red
                        ? Colors.red
                        : AppColors.APP_COLOR, BlendMode.srcIn),
                  ),
                const SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    text.tr(),
                    style: AppTextStyles.menuItem.copyWith(
                        fontSize: fontSize, color: fColor, fontWeight: fwight),
                  ),
                ),
              ],
            ),
          ),
          hasArrow
              ? SizedBox(
                  height: 18, child: SvgPicture.asset(Images.FORWARD_ARROW))
              : const SizedBox()
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    if (_selectedImage != null) {
      return Image.file(
        File(_selectedImage!.path),
        width: 80,
        height: 80,
        fit: BoxFit.cover,
      );
    }

    final logo = _logoUrl ?? AppUtils.appUser?.logo;
    if (logo != null && logo.isNotEmpty) {
      final imageUrl = Api.baseUrl.endsWith('/')
          ? '${Api.baseUrl}$logo'
          : '${Api.baseUrl}/$logo';
      return Image.network(
        imageUrl,
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            Images.PROFILE_COVER,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          );
        },
      );
    }

    return Image.asset(
      Images.PROFILE_COVER,
      width: 80,
      height: 80,
      fit: BoxFit.cover,
    );
  }

  Future<void> _pickAndUploadImage() async {
    final pickedImage = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedImage == null) return;

    setState(() {
      _selectedImage = pickedImage;
      _isUploading = true;
    });

    try {
      final user = AppUtils.appUser;
      if (user == null) {
        AppUtils.showCustomSnackbar('user_not_found'.tr(), SnackType.FAILURE);
        return;
      }

      final uri =
          Uri.parse('${Api.baseUrl}dashboard-mobile/update-school-icon/');
      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'username': user.username,
        'app-key': user.ky,
        'Accept-Language': 'ar',
      });

      request.files
          .add(await http.MultipartFile.fromPath('icon', pickedImage.path));
      request.files
          .add(await http.MultipartFile.fromPath('logo', pickedImage.path));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final data = jsonDecode(responseBody);
        String? newLogo;
        if (data is Map<String, dynamic>) {
          if (data['data'] != null && data['data'] is Map<String, dynamic>) {
            newLogo = data['data']['logo']?.toString();
          }
          newLogo ??= data['logo']?.toString();
        }

        if (newLogo != null && newLogo.isNotEmpty) {
          final updatedUser = AppUser(
            id: user.id,
            school: user.school,
            username: user.username,
            schoolSystem: user.schoolSystem,
            dateSystem: user.dateSystem,
            isSmartbleActive: user.isSmartbleActive,
            isFollowerActive: user.isFollowerActive,
            smartblePlanInfo: user.smartblePlanInfo,
            followerPlanInfo: user.followerPlanInfo,
            whatsappService: user.whatsappService,
            smsService: user.smsService,
            ky: user.ky,
            password: user.password,
            logo: newLogo,
            data_follower: user.data_follower,
          );
          await AppUtils.instance.setUser(updatedUser);
          setState(() {
            _logoUrl = newLogo;
            _selectedImage = null;
          });
          AppUtils.showCustomSnackbar(
              'image_changed_success'.tr(), SnackType.SUCESS);
        } else {
          AppUtils.showCustomSnackbar(
              'image_upload_no_logo'.tr(), SnackType.FAILURE);
        }
      } else {
        AppUtils.showCustomSnackbar(responseBody, SnackType.FAILURE);
      }
    } catch (e) {
      AppUtils.showCustomSnackbar('image_upload_failed'.tr(), SnackType.FAILURE);
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: MyAppBar(title: 'account'.tr()),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Center(
                child: Column(
                  children: [
                    ClipOval(
                      child: _buildProfileImage(),
                    ),
                    Text(
                      AppUtils.appUser?.school ?? '',
                      style: AppTextStyles.profileName,   // 18sp bold
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      "${"@".tr()}${AppUtils.appUser!.username}",
                      style: AppTextStyles.profileInfo.copyWith(   // 16sp regular
                          color: AppColors.BORDERGREYCOLOR),
                    ),
                    const SizedBox(
                      height: 5,
                    ),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BtnApp(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 10),
                          label: _isUploading ? '...' : 'تعديل الصورة',
                          onTap: _isUploading ? () {} : _pickAndUploadImage,
                          radius: 15,
                        ),
                      ],
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //     // Get.toNamed(RouteHelper.getEditProfileRoute());
                    //     AppUtils.go(EditProfile());
                    //   },
                    //   child: Container(
                    //     width: 230,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //         color: const Color(0xffF5F6FA),
                    //         borderRadius: BorderRadius.circular(15),
                    //         border: Border.all(color: const Color(0xffB5B5B5))),
                    //     child: Center(
                    //       child: Text("edit_profile".tr()),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // GestureDetector(
                    //   onTap: () {
                    //     chooseLangDialog(context,
                    //             AppUtils.instance.getLocale().languageCode)
                    //         .show();
                    //   },
                    //   child: Container(
                    //     width: 230,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //         color: const Color(0xffF5F6FA),
                    //         borderRadius: BorderRadius.circular(15),
                    //         border: Border.all(color: const Color(0xffB5B5B5))),
                    //     child: Center(
                    //       child: Text("language".tr()),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // GestureDetector(
                    //   onTap: () {
                    //     // Get.toNamed(RouteHelper.getEditProfileRoute());
                    //     AppUtils.instance.logout();
                    //     AppUtils.goAndReplace(const LoginScreen());
                    //   },
                    //   child: Container(
                    //     width: 230,
                    //     height: 50,
                    //     decoration: BoxDecoration(
                    //         color: const Color(0xffF5F6FA),
                    //         borderRadius: BorderRadius.circular(15),
                    //         border: Border.all(color: const Color(0xffB5B5B5))),
                    //     child: Center(
                    //       child: Text("logout".tr()),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // _customBox(
              //     hasArrow: false,
              //     text: "dashboard",
              //     fColor: const Color(0xff1A6A7D),
              //     fwight: FontWeight.w900,
              //     fontSize: 19),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(EditPassword()),
              //     child: _customBox(text: "edit_password")),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(Invoice()),
              //     child: _customBox(text: "invoices".tr())),
              // if (AppUtils.permissions.isNotEmpty &&
              //         AppUtils.permissions.any((p) =>
              //             p.contains("/daily-supervision/delete--bulk/")) ||
              //     AppUtils.permissions.isEmpty)
              InkWell(
                  onTap: () {
                    chooseLangDialog(
                            context, AppUtils.instance.getLocale().languageCode)
                        .show();
                  },
                  child: _customBox(
                      text: "language",
                      icon: "assets/icons/material-symbols_language.svg")),
              InkWell(
                  onTap: () => AppUtils.go(const ManagerSignature()),
                  child: _customBox(
                      text: "manager_signature",
                      icon: "assets/icons/signature.svg")),
              InkWell(
                  onTap: () => AppUtils.go(const SubscriptionManager()),
                  child: _customBox(
                      text: "manage_subscribtion",
                      icon: "assets/icons/ep_list.svg")),
              InkWell(
                  onTap: () => AppUtils.go(const TermsConditions()),
                  child: _customBox(
                      text: "terms_conditions_title",
                      icon: "assets/icons/octicon_checklist-16.svg")),
              InkWell(
                  onTap: () => AppUtils.go(const ContactUs()),
                  // ضغطة مطوّلة تفتح حالة الإشعارات: يحتاجها الدعم لتشخيص
                  // «لا تصلني إشعارات» دون سجلّ Xcode، ولا تعترض المستخدم.
                  onLongPress: () => showNotificationsDiagnostics(context),
                  child: _customBox(
                      text: "contact_us",
                      icon: "assets/icons/call_us_icon.svg")),
              InkWell(
                  onTap: () {},
                  child: _customBox(
                      text: "delete_account",
                      icon: "assets/icons/icomoon-free_bin.svg")),
              InkWell(
                  onTap: () {
                    AppUtils.instance.logout();
                    AppUtils.goAndReplace(const LoginScreen());
                  },
                  child: _customBox(
                      text: "logout",
                      icon: "assets/icons/material-symbols_logout-sharp.svg")),

              // const Divider(),
              // GestureDetector(
              //     onTap: () {
              //       AwesomeDialog(
              //         context: context,
              //         dialogType: DialogType.warning,
              //         title: 'delete_account'.tr(),
              //         desc: 'are_you_sure'.tr(),
              //         btnCancelOnPress: () {},
              //         btnOkOnPress: () {
              //           // Add your delete account logic here
              //         },
              //       ).show();
              //     },
              //     child: _customBox(text: "delete_account")),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(MarketeingCode()),
              //     child: _customBox(text: "get_your_code")),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(RegionLanguage()),
              //     child: _customBox(text: "zone")),
              // const Divider(),
              // const SizedBox(
              //   height: 55,
              // ),
              // _customBox(
              //     hasArrow: false,
              //     text: "app_info",
              //     fColor: const Color(0xff1A6A7D),
              //     fwight: FontWeight.w900,
              //     fontSize: 19),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(TermsConditions()),
              //     // Get.toNamed(RouteHelper.gettermsConditionsRoute()),
              //     child: _customBox(text: "terms-conditions")),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(Faq()),
              //     child: _customBox(text: "faq")),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(WhoWeAre()),
              //     child: _customBox(text: "wo_we_are")),
              // const Divider(),
              // GestureDetector(
              //     onTap: () => AppUtils.go(ContactUs()),
              //     child: _customBox(text: "contact_us")),
              // const Divider(),
              // const SizedBox(
              //   height: 154,
              // ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     SvgPicture.asset(Images.SEND_TWO),
              //     const SizedBox(
              //       width: 20,
              //     ),
              //     Text(
              //       "شارك التطبيق مع زملائك",
              //       style: AbhayaLibre.copyWith(
              //           fontSize: 18, color: const Color(0xffA5910B)),
              //     ),
              //   ],
              // ),
              // Image.asset(
              //   Images.BOTTOM_GROUND,
              //   color: Colors.grey,
              // )
            ],
          ),
        ),
      ),
    );
  }
}
