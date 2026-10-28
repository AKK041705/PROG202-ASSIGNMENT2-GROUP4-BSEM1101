import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../state/app_state.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/request_card.dart';
import '../../widgets/responsive_body.dart';

/// Driver tab: pending requests that match the driver's vehicle type.
class DriverRequestsView extends StatelessWidget {
  const DriverRequestsView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final driver = state.currentUser!;
        final items = state.incomingFor(driver);
        return RefreshIndicator(
          color: AppColors.green,
          onRefresh: () async => state.refresh(),
          child: ResponsiveBody(
            scroll: false,
            child: ListView(
              children: [
                if (!driver.verified)
                  NoteBox(
                    text: 'Your account is waiting for verification by the administrator. '
                        'You cannot receive requests yet.',
                    icon: Icons.hourglass_top,
                    color: AppColors.amber,
                    background: AppColors.amberTint,
                  )
                else ...[
                  Text(
                    'Pending requests for ${driver.driverType} drivers',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text('Pull down to refresh.', style: TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  if (items.isEmpty)
                    const EmptyState(
                      icon: Icons.inbox_outlined,
                      title: 'No pending requests',
                      message: 'New requests from passengers appear here.',
                    ),
                  for (final r in items)
                    RequestCard(
                      request: r,
                      subtitle: 'Passenger: ${state.findUser(r.passenger)?.name ?? r.passenger}',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.requestDetails, arguments: r.id),
                    ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
