import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/conts/app_text_styles.dart';
import 'package:adary/features/adary/data/models/app_notification.dart';
import 'package:adary/features/adary/presentation/bloc/notifications/notifications_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// قائمة إشعارات المدير كما يحفظها الخادم.
///
/// الخادم يعلّمها مقروءةً بمجرّد ردّه على `notifications/`، فالدخول إلى هذه
/// الشاشة هو ما يصفّر الشارة — لا فعلٌ منفصل.
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final _cubit = NotificationsCubit.instance;

  @override
  void initState() {
    super.initState();
    _cubit.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.APP_COLOR,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('notifications_title'.tr(), style: AppTextStyles.appBarTitle),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        bloc: _cubit,
        builder: (context, state) {
          if (state.loading && state.items.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.failed && state.items.isEmpty) {
            return _Message(
              icon: Icons.wifi_off_rounded,
              text: 'تعذّر جلب الإشعارات. تأكّد من اتصالك ثم أعد المحاولة.',
              onRetry: _cubit.load,
            );
          }
          if (state.items.isEmpty) {
            return const _Message(
              icon: Icons.notifications_none_rounded,
              text: 'لا توجد إشعارات بعد.',
            );
          }
          return RefreshIndicator(
            onRefresh: _cubit.load,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: state.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) => _NotificationCard(
                data: state.items[index],
                onDelete: () => _cubit.remove(state.items[index].id),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.data, required this.onDelete});

  final AppNotification data;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(data.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 7),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // نقطة للجديد فقط: القائمة تُقرأ دفعةً واحدة فلا يبقى غيرها
                // ما يميّز ما لم يُقرأ قبل فتح الشاشة.
                color: data.newMessage
                    ? AppColors.APP_COLOR
                    : Colors.transparent,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.message,
                      style: AppTextStyles.secondaryBold
                          .copyWith(color: AppColors.triblethree)),
                  if (data.createdAt != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('yyyy/MM/dd — hh:mm a')
                          .format(data.createdAt!.toLocal()),
                      style: AppTextStyles.captionText
                          .copyWith(color: AppColors.GREYFONTCOLOR),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.onRetry});

  final IconData icon;
  final String text;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: AppColors.BORDERGREYCOLOR),
            const SizedBox(height: 12),
            Text(text,
                textAlign: TextAlign.center,
                style: AppTextStyles.secondary
                    .copyWith(color: AppColors.GREYFONTCOLOR)),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              TextButton(onPressed: onRetry, child: const Text('إعادة المحاولة')),
            ],
          ],
        ),
      ),
    );
  }
}
