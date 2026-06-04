import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/style.dart';
import 'package:adary/features/adary/data/models/requests_model.dart';
import 'package:adary/features/adary/presentation/bloc/scure_session.dart/secure_session_bloc.dart';
import 'package:adary/features/adary/presentation/widgets/secure_sessions/card_secure_session.dart';
import 'package:adary/features/adary/presentation/widgets/secure_sessions/items_secure_session.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecureSessions extends StatelessWidget {
  const SecureSessions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<SecureSessionBloc>(),
      child: DefaultTabController(
        length: 3,
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              iconTheme: const IconThemeData(color: AppColors.APP_COLOR),
              title: Text(
                'طلبات تأمين الحصة'.tr(),
                style: AbhayaLibre.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.APP_COLOR,
                ),
              ),
            ),
            body: Column(
              children: [
                /// 🔹 Segmented TabBar
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.APP_COLOR),
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: AppColors.APP_COLOR,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.APP_COLOR,
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    splashFactory: NoSplash.splashFactory,
                    overlayColor: MaterialStateProperty.all(
                      Colors.transparent,
                    ),
                    tabs: [
                      Tab(text: 'قيد الإنتظار'.tr()),
                      Tab(text: 'المكتملة'.tr()),
                      Tab(text: 'المرفوضة'.tr()),
                    ],
                  ),
                ),

                /// 🔹 المحتوى
                const Expanded(
                  child: TabBarView(
                    children: [
                      ItemsSecureSession(status: RequestStatus.pending),
                      ItemsSecureSession(status: RequestStatus.accepted),
                      ItemsSecureSession(status: RequestStatus.rejected),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
