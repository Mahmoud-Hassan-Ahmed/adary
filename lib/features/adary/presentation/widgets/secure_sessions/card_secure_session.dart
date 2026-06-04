import 'package:adary/features/adary/data/models/requests_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

enum RequestStatus {
  pending,
  accepted,
  rejected,
}

class LeaveRequestCard extends StatelessWidget {
  final LeaveRequestModel leaveRequestModel;
  final RequestStatus status;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const LeaveRequestCard({
    super.key,
    required this.status,
    this.onAccept,
    this.onReject,
    required this.leaveRequestModel,
  });

  Color get statusColor {
    switch (status) {
      case RequestStatus.pending:
        return Colors.orange;
      case RequestStatus.accepted:
        return Colors.green;
      case RequestStatus.rejected:
        return Colors.red;
    }
  }

  Color get statusColorText {
    switch (status) {
      case RequestStatus.pending:
        return const Color.fromRGBO(189, 81, 38, 1);
      case RequestStatus.accepted:
        return const Color.fromRGBO(67, 146, 138, 1);
      case RequestStatus.rejected:
        return const Color.fromRGBO(255, 21, 26, 1);
    }
  }

  String get statusText {
    switch (status) {
      case RequestStatus.pending:
        return "قيد الانتظار";
      case RequestStatus.accepted:
        return "مقبول";
      case RequestStatus.rejected:
        return "مرفوض";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.cyan.shade200,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              const Icon(Icons.person_outline, color: Colors.cyan),
              const SizedBox(width: 6),
              Text(
                leaveRequestModel.applicant.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColorText.withOpacity(.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColorText,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              SvgPicture.asset(
                "assets/icons/book.svg",
              ),
              const SizedBox(width: 6),
              Text(
                leaveRequestModel.applicant.name,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/uil_calender.svg",
                    ),
                    const SizedBox(width: 6),
                    Text(
                      leaveRequestModel.updatedAt.toString().split("T").first,
                      style: TextStyle(
                        color: Colors.cyan.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      "assets/icons/hour.svg",
                    ),
                    const SizedBox(width: 6),
                    Text(
                      leaveRequestModel.updatedAt
                          .toString()
                          .split("T")
                          .last
                          .substring(0, 5),
                      style: TextStyle(
                        color: Colors.cyan.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (status != RequestStatus.pending)
            Divider(
              height: 24,
              color: Colors.grey.shade300,
            ),
          if (status == RequestStatus.pending) const SizedBox(height: 10),

          RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
              ),
              children: [
                const TextSpan(
                  text: "سبب التأمين : ",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: leaveRequestModel.lesson,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          RichText(
            textAlign: TextAlign.right,
            text: TextSpan(
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 13,
              ),
              children: [
                const TextSpan(
                  text: "المعلم البديل : ",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.cyan,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: leaveRequestModel.substitute.name,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          if (status == RequestStatus.pending)
            Divider(
              height: 24,
              color: Colors.grey.shade300,
            ),

          /// Buttons only for pending
          if (status == RequestStatus.pending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onReject,
                    icon: const Icon(Icons.close),
                    label: const Text("رفض"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.red, width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onAccept,
                    icon: const Icon(Icons.check),
                    label: const Text("قبول"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(33, 54, 147, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
