import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/request_card.dart';
import '../../widgets/responsive_body.dart';

/// Driver tab: trips the driver has accepted, confirmed or completed.
class DriverTripsView extends StatelessWidget {
  const DriverTripsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final trips = state.tripsOfDriver(state.currentUser!.username);
        return RefreshIndicator(
          color: AppColors.green,
          onRefresh: () async => state.refresh(),
          child: ResponsiveBody(
            scroll: false,
            child: trips.isEmpty
                ? ListView(
                    children: const [
                      EmptyState(
                        icon: Icons.route_outlined,
                        title: 'No trips yet',
                        message: 'Requests you accept will appear here.',
                      ),
                    ],
                  )
                : ListView(
                    children: [
                      for (final r in trips)
                        RequestCard(
                          request: r,
                          subtitle: r.status == RequestStatus.confirmed
                              ? 'Confirmed. Open to mark the trip as completed.'
                              : null,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.requestDetails, arguments: r.id),
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
