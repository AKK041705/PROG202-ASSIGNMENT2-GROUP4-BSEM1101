import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/request_card.dart';
import '../../widgets/responsive_body.dart';

/// The passenger's requests in two tabs: Active and History.
class MyRequestsView extends StatelessWidget {
  const MyRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Material(
            color: AppColors.surface,
            child: TabBar(
              labelColor: AppColors.green,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.green,
              tabs: [Tab(text: 'Active'), Tab(text: 'History')],
            ),
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: state,
              builder: (context, _) {
                final mine = state.requestsOfPassenger(state.currentUser!.username);
                final active = mine.where((r) => r.status.isActive).toList();
                final history = mine.where((r) => !r.status.isActive).toList();
                return TabBarView(
                  children: [
                    _list(context, active, 'No active requests', 'Request a ride and it will appear here.'),
                    _list(context, history, 'No past requests', 'Completed and cancelled requests appear here.'),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _list(BuildContext context, List<TransportRequest> items, String title, String message) {
    return RefreshIndicator(
      color: AppColors.green,
      onRefresh: () async => AppState.instance.refresh(),
      child: ResponsiveBody(
        scroll: false,
        child: items.isEmpty
            ? ListView(children: [EmptyState(icon: Icons.inbox_outlined, title: title, message: message)])
            : ListView(
                children: [
                  for (final r in items)
                    RequestCard(
                      request: r,
                      subtitle: r.status == RequestStatus.awaitingPassenger
                          ? 'A driver accepted. Open to accept or reject.'
                          : null,
                      onTap: () => Navigator.pushNamed(context, AppRoutes.requestDetails, arguments: r.id),
                    ),
                ],
              ),
      ),
    );
  }
}
