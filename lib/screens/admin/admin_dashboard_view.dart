import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../widgets/app_card.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/request_card.dart';
import '../../widgets/responsive_body.dart';
import '../../widgets/status_chip.dart';

/// Administrator home: what needs attention, key numbers and simple charts.
class AdminDashboardView extends StatelessWidget {
  const AdminDashboardView({super.key, required this.onOpenTab});

  final ValueChanged<int> onOpenTab;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final drivers = state.drivers;
        final waiting = drivers.where((d) => !d.verified).length;
        final passengers = state.users.where((u) => u.role == UserRole.passenger).length;
        int count(RequestStatus s) => state.requests.where((r) => r.status == s).length;
        final pendingReports = state.reports.where((r) => r.status == ReportStatus.pendingReview).length;
        final pendingRequests = count(RequestStatus.pending);
        final totalRequests = state.requests.length;
        final recent = state.requests.reversed.take(3).toList();
        final recentReports = state.reports.reversed.take(2).toList();

        final sources = <String, int>{};
        for (final t in state.tariffs) {
          sources[t.source] = (sources[t.source] ?? 0) + 1;
        }

        return ResponsiveBody(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(18)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Administrator dashboard',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${drivers.length} drivers  |  $totalRequests requests  |  ${state.reports.length} reports',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SectionTitle('Needs your attention'),
              if (waiting == 0 && pendingReports == 0 && pendingRequests == 0)
                NoteBox(
                  text: 'All caught up. Nothing is waiting for you.',
                  icon: Icons.check_circle_outline,
                  color: AppColors.success,
                  background: AppColors.successTint,
                ),
              if (waiting > 0)
                AttentionTile(
                  icon: Icons.badge_outlined,
                  text: 'Drivers waiting for verification',
                  count: waiting,
                  onTap: () => onOpenTab(1),
                ),
              if (pendingReports > 0)
                AttentionTile(
                  icon: Icons.flag_outlined,
                  text: 'Fare reports to review',
                  count: pendingReports,
                  onTap: () => onOpenTab(3),
                ),
              if (pendingRequests > 0)
                AttentionTile(
                  icon: Icons.hourglass_top,
                  text: 'Requests still waiting for a driver',
                  count: pendingRequests,
                ),
              const SectionTitle('Overview'),
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisExtent: 140,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [
                  StatCard(label: 'Passengers', value: '$passengers', icon: Icons.people_outline),
                  StatCard(
                    label: 'Verified drivers',
                    value: '${drivers.length - waiting}',
                    icon: Icons.verified_outlined,
                    onTap: () => onOpenTab(1),
                  ),
                  StatCard(
                    label: 'Fare records',
                    value: '${state.tariffs.length}',
                    icon: Icons.payments_outlined,
                    onTap: () => onOpenTab(2),
                  ),
                  StatCard(label: 'Requests', value: '$totalRequests', icon: Icons.list_alt),
                  StatCard(label: 'Completed trips', value: '${count(RequestStatus.completed)}', icon: Icons.flag_circle_outlined),
                  StatCard(
                    label: 'Fare reports',
                    value: '${state.reports.length}',
                    icon: Icons.flag_outlined,
                    onTap: () => onOpenTab(3),
                  ),
                ],
              ),
              const SectionTitle('Requests by status'),
              AppCard(
                child: Column(
                  children: [
                    BarRow(label: 'Pending', value: count(RequestStatus.pending), total: totalRequests, color: AppColors.amber),
                    BarRow(label: 'Awaiting passenger', value: count(RequestStatus.awaitingPassenger), total: totalRequests, color: AppColors.info),
                    BarRow(label: 'Confirmed', value: count(RequestStatus.confirmed), total: totalRequests, color: AppColors.green),
                    BarRow(label: 'Completed', value: count(RequestStatus.completed), total: totalRequests, color: AppColors.success),
                    BarRow(label: 'Cancelled', value: count(RequestStatus.cancelled), total: totalRequests, color: AppColors.red),
                  ],
                ),
              ),
              const SectionTitle('Fare records by source'),
              AppCard(
                child: Column(
                  children: [
                    for (final entry in sources.entries)
                      BarRow(
                        label: entry.key,
                        value: entry.value,
                        total: state.tariffs.length,
                        color: entry.key == 'Administrator update' ? AppColors.info : AppColors.green,
                      ),
                  ],
                ),
              ),
              const SectionTitle('Recent requests'),
              if (recent.isEmpty)
                const EmptyState(
                  icon: Icons.inbox_outlined,
                  title: 'No requests yet',
                  message: 'Requests from passengers will appear here.',
                ),
              for (final r in recent)
                RequestCard(
                  request: r,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.requestDetails, arguments: r.id),
                ),
              SectionTitle('Latest fare reports', actionLabel: 'See all', onAction: () => onOpenTab(3)),
              if (recentReports.isEmpty) const NoteBox(text: 'No fare reports yet.'),
              for (final r in recentReports)
                AppCard(
                  margin: const EdgeInsets.only(bottom: 8),
                  onTap: () => Navigator.pushNamed(context, AppRoutes.reviewReport, arguments: r.id),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${r.id}  |  ${r.mode}', style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(r.route, style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          ],
                        ),
                      ),
                      StatusChip.report(r.status),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
