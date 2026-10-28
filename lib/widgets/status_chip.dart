import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../models/models.dart';

/// Small coloured label such as "Pending" or "Confirmed".
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.textColor,
    required this.background,
  });

  factory StatusChip.request(RequestStatus status) {
    switch (status) {
      case RequestStatus.pending:
        return StatusChip(label: status.label, textColor: AppColors.amber, background: AppColors.amberTint);
      case RequestStatus.awaitingPassenger:
        return StatusChip(label: status.label, textColor: AppColors.blue, background: AppColors.blueTint);
      case RequestStatus.confirmed:
        return StatusChip(label: status.label, textColor: AppColors.success, background: AppColors.successTint);
      case RequestStatus.completed:
        return StatusChip(label: status.label, textColor: Colors.white, background: AppColors.success);
      case RequestStatus.cancelled:
        return StatusChip(label: status.label, textColor: AppColors.red, background: AppColors.redTint);
    }
  }

  factory StatusChip.report(ReportStatus status) {
    switch (status) {
      case ReportStatus.pendingReview:
        return StatusChip(label: status.label, textColor: AppColors.amber, background: AppColors.amberTint);
      case ReportStatus.underReview:
        return StatusChip(label: status.label, textColor: AppColors.blue, background: AppColors.blueTint);
      case ReportStatus.closed:
        return StatusChip(label: status.label, textColor: AppColors.success, background: AppColors.successTint);
    }
  }

  final String label;
  final Color textColor;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w700),
      ),
    );
  }
}
