import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../state/app_state.dart';
import '../../widgets/app_card.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/responsive_body.dart';
import '../../widgets/status_chip.dart';

/// Administrator tab: all fare issue reports.
class AdminReportsView extends StatelessWidget {
  const AdminReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final reports = state.reports.reversed.toList();
        return RefreshIndicator(
          color: AppColors.green,
          onRefresh: () async => state.refresh(),
          child: ResponsiveBody(
            scroll: false,
            child: reports.isEmpty
                ? ListView(
                    children: const [
                      EmptyState(
                        icon: Icons.flag_outlined,
                        title: 'No reports yet',
                        message: 'Fare issue reports from passengers will appear here.',
                      ),
                    ],
                  )
                : ListView(
                    children: [
                      for (final r in reports)
                        AppCard(
                          margin: const EdgeInsets.only(bottom: 10),
                          onTap: () => Navigator.pushNamed(context, AppRoutes.reviewReport, arguments: r.id),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text('${r.id}  |  ${r.mode}',
                                        style: const TextStyle(fontWeight: FontWeight.w700)),
                                  ),
                                  StatusChip.report(r.status),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(r.route, style: TextStyle(color: AppColors.textSecondary)),
                              Text('Reported: NLe ${r.reported.toStringAsFixed(1)}  |  System: ${r.systemFare}',
                                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            ],
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
