import 'package:flutter/material.dart';

import '../../core/ui_helpers.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/responsive_body.dart';
import '../../widgets/status_chip.dart';

/// Administrator reviews one fare issue report: set the status and reply.
class ReviewReportScreen extends StatefulWidget {
  const ReviewReportScreen({super.key, required this.reportId});

  final String reportId;

  @override
  State<ReviewReportScreen> createState() => _ReviewReportScreenState();
}

class _ReviewReportScreenState extends State<ReviewReportScreen> {
  final _messageController = TextEditingController();
  String _status = 'Under Review';

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final report = state.reportById(widget.reportId);
    if (report == null) {
      return Scaffold(
        appBar: const AppTopBar(title: 'Report'),
        body: const EmptyState(
          icon: Icons.search_off,
          title: 'Report not found',
          message: 'This report is no longer available.',
        ),
      );
    }
    return Scaffold(
      appBar: AppTopBar(title: report.id),
      body: SafeArea(
        child: ResponsiveBody(
          maxWidth: 560,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatusChip.report(report.status),
                    const SizedBox(height: 10),
                    InfoRow('Passenger', state.findUser(report.passenger)?.name ?? report.passenger),
                    InfoRow('Route', report.route),
                    InfoRow('Mode', report.mode),
                    InfoRow('Reported fare', 'NLe ${report.reported.toStringAsFixed(1)}'),
                    InfoRow('System fare', report.systemFare),
                    InfoRow('Description', report.note),
                  ],
                ),
              ),
              const SectionTitle('Your decision'),
              const NoteBox(text: 'A report is a record for review. It is not a finding of fault.'),
              const SizedBox(height: 14),
              AppDropdown(
                label: 'Set status',
                icon: Icons.rule,
                value: _status,
                items: const ['Under Review', 'Closed'],
                onChanged: (v) => setState(() => _status = v ?? _status),
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: _messageController,
                label: 'Message to the passenger (optional)',
                icon: Icons.message_outlined,
                maxLines: 3,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Save and notify passenger',
                icon: Icons.send,
                onPressed: () {
                  state.reviewReport(
                    report,
                    _status == 'Closed' ? ReportStatus.closed : ReportStatus.underReview,
                    _messageController.text,
                  );
                  showMessage(context, 'Report ${report.id} updated.');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
