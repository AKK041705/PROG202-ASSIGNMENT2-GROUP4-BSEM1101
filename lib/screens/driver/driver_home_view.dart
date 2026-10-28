import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/request_card.dart';
import '../../widgets/responsive_body.dart';

/// Driver home: verification status, key numbers and the next trip.
class DriverHomeView extends StatelessWidget {
  const DriverHomeView({super.key, required this.onOpenTab});

  final ValueChanged<int> onOpenTab;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final driver = state.currentUser!;
        final incoming = state.incomingFor(driver).length;
        final trips = state.tripsOfDriver(driver.username);
        final active = trips.where((t) => t.status == RequestStatus.confirmed || t.status == RequestStatus.awaitingPassenger).toList();
        final completed = trips.where((t) => t.status == RequestStatus.completed).length;
        final unread = state.unreadCount(driver.username);

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
                    Text(
                      'Hello, ${driver.name.split(' ').first}',
                      style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${driver.driverType ?? ''} driver  |  ${driver.vehicle ?? ''}  |  ${driver.plate ?? ''}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              if (!driver.verified)
                NoteBox(
                  text: 'Your account is waiting for verification by the administrator. You cannot receive requests yet.',
                  icon: Icons.hourglass_top,
                  color: AppColors.amber,
                  background: AppColors.amberTint,
                )
              else
                NoteBox(
                  text: 'Your account is verified. You can receive requests for ${driver.driverType} trips.',
                  icon: Icons.verified_outlined,
                  color: AppColors.success,
                  background: AppColors.successTint,
                ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(child: MiniStat(label: 'New requests', value: '$incoming', icon: Icons.inbox_outlined)),
                  const SizedBox(width: 10),
                  Expanded(child: MiniStat(label: 'Active trips', value: '${active.length}', icon: Icons.route_outlined)),
                  const SizedBox(width: 10),
                  Expanded(child: MiniStat(label: 'Completed', value: '$completed', icon: Icons.flag_circle_outlined)),
                ],
              ),
              const SectionTitle('Quick actions'),
              GridView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  mainAxisExtent: 142,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [
                  ActionTile(
                    label: 'Incoming requests',
                    icon: Icons.inbox_outlined,
                    badge: incoming,
                    onTap: () => onOpenTab(1),
                  ),
                  ActionTile(label: 'My trips', icon: Icons.route_outlined, onTap: () => onOpenTab(2)),
                  ActionTile(
                    label: 'View fares',
                    icon: Icons.payments_outlined,
                    onTap: () => Navigator.pushNamed(context, AppRoutes.fares),
                  ),
                  ActionTile(
                    label: 'Notifications',
                    icon: Icons.notifications_none,
                    badge: unread,
                    onTap: () => onOpenTab(3),
                  ),
                ],
              ),
              const SectionTitle('Next trip'),
              if (active.isEmpty)
                const EmptyState(
                  icon: Icons.route_outlined,
                  title: 'No active trips',
                  message: 'Accept a request and your trip will appear here.',
                )
              else
                RequestCard(
                  request: active.first,
                  onTap: () => Navigator.pushNamed(context, AppRoutes.requestDetails, arguments: active.first.id),
                ),
            ],
          ),
        );
      },
    );
  }
}
