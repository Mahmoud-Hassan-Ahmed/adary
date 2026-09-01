import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/presentation/bloc/notifications/notifications_cubit.dart';
import 'package:adary/features/adary/presentation/pages/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// جرس الإشعارات وشارة غير المقروء في رأس الصفحة.
///
/// العدّاد يُجلب عند البناء وعند العودة من القائمة — لا دوريًا: الخادم يصفّره
/// عند فتح القائمة، ونداءٌ دوريٌّ بعدها لا يضيف إلا حِملًا على الشبكة.
class NotificationsBell extends StatefulWidget {
  const NotificationsBell({super.key, required this.size});

  final double size;

  @override
  State<NotificationsBell> createState() => _NotificationsBellState();
}

class _NotificationsBellState extends State<NotificationsBell> {
  final _cubit = NotificationsCubit.instance;

  @override
  void initState() {
    super.initState();
    _cubit.refreshCount();
  }

  Future<void> _open() async {
    await AppUtils.goWait(const NotificationScreen());
    // القائمة صفّرت المقروء في الخادم؛ يُعاد الجلب تحسّبًا لإشعارٍ وصل أثناء
    // فتحها.
    await _cubit.refreshCount();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationsCubit, NotificationsState>(
      bloc: _cubit,
      builder: (context, state) {
        return InkWell(
          onTap: _open,
          borderRadius: BorderRadius.circular(widget.size),
          child: SizedBox(
            width: widget.size,
            height: widget.size,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.white,
                  size: widget.size * 0.62,
                ),
                if (state.unread > 0)
                  PositionedDirectional(
                    top: widget.size * 0.12,
                    end: widget.size * 0.08,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 1),
                      constraints: const BoxConstraints(minWidth: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: Text(
                        // ما زاد على تسعةٍ وتسعين يُختصر: الشارة تضيق بالرقم
                        // فتزحزح ما حولها في الرأس.
                        state.unread > 99 ? '99+' : '${state.unread}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
