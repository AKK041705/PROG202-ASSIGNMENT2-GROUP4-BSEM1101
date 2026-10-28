import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/ui_helpers.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/fare_tile.dart';
import '../../widgets/responsive_body.dart';
import '../../widgets/status_chip.dart';

/// Shows one request. The buttons at the bottom depend on who is looking:
/// the passenger can accept or reject the driver, the driver can accept,
/// decline or complete, and the administrator can only view.
class RequestDetailsScreen extends StatelessWidget {
  const RequestDetailsScreen({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final request = state.requestById(requestId);
        final user = state.currentUser;
        if (request == null || user == null) {
          return Scaffold(
            appBar: const AppTopBar(title: 'Request'),
            body: const EmptyState(
              icon: Icons.search_off,
              title: 'Request not found',
              message: 'This request is no longer available.',
            ),
          );
        }
        final passenger = state.findUser(request.passenger);
        final driver = request.driver == null ? null : state.findUser(request.driver!);

        return Scaffold(
          appBar: AppTopBar(title: request.id),
          body: SafeArea(
            child: ResponsiveBody(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 46,
                              height: 46,
                              decoration: BoxDecoration(color: AppColors.greenTint, shape: BoxShape.circle),
                              child: Icon(modeIcon(request.mode), color: AppColors.green),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                '${request.pickup} to ${request.destination}',
                                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        StatusChip.request(request.status),
                        const SizedBox(height: 12),
                        InfoRow('Transport', request.mode),
                        InfoRow('People', '${request.people}'),
                        InfoRow('Extra seats free', '${request.freeSeats}'),
                        InfoRow('Estimated fare', request.fareText),
                        if (request.note.isNotEmpty) InfoRow('Note', request.note),
                      ],
                    ),
                  ),
                  if (user.role == UserRole.driver || user.role == UserRole.administrator) ...[
                    const SectionTitle('Passenger'),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoRow('Name', passenger?.name ?? request.passenger),
                          InfoRow('Phone', passenger?.phone ?? '-'),
                        ],
                      ),
                    ),
                  ],
                  if (driver != null && user.role != UserRole.driver) ...[
                    const SectionTitle('Driver'),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InfoRow('Name', driver.name),
                          InfoRow('Phone', driver.phone),
                          InfoRow('Vehicle', driver.vehicle ?? '-'),
                          InfoRow('Plate', driver.plate ?? '-'),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ..._actions(context, state, request, user),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _actions(BuildContext context, AppState state, TransportRequest request, AppUser user) {
    final status = request.status;

    if (user.role == UserRole.passenger && request.passenger == user.username) {
      if (status == RequestStatus.awaitingPassenger) {
        return [
          const NoteBox(text: 'A driver accepted your request. Do you accept this driver?'),
          const SizedBox(height: 12),
          PrimaryButton(
            label: 'Accept this driver',
            icon: Icons.check_circle_outline,
            onPressed: () {
              state.passengerAcceptDriver(request);
              showMessage(context, 'Driver accepted. Trip confirmed.');
            },
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            label: 'Reject this driver',
            icon: Icons.person_off_outlined,
            color: AppColors.red,
            onPressed: () async {
              final ok = await confirmAction(
                context,
                title: 'Reject this driver?',
                message: 'Your request will go back to Pending so another driver can accept it.',
                confirmLabel: 'Reject',
              );
              if (!ok || !context.mounted) return;
              state.passengerRejectDriver(request);
              showMessage(context, 'Driver rejected. Your request is Pending again.');
            },
          ),
          const SizedBox(height: 10),
          _cancelButton(context, state, request),
        ];
      }
      if (status == RequestStatus.pending || status == RequestStatus.confirmed) {
        return [
          if (status == RequestStatus.pending)
            const NoteBox(text: 'Waiting for a verified driver to accept your request.'),
          if (status == RequestStatus.pending) const SizedBox(height: 12),
          _cancelButton(context, state, request),
        ];
      }
    }

    if (user.role == UserRole.driver) {
      if (status == RequestStatus.pending && !request.declinedDrivers.contains(user.username)) {
        return [
          PrimaryButton(
            label: 'Accept this request',
            icon: Icons.check_circle_outline,
            onPressed: () {
              state.driverAccept(request, user);
              showMessage(context, 'You accepted ${request.id}. Waiting for the passenger.');
            },
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            label: 'Decline this request',
            icon: Icons.close,
            color: AppColors.red,
            onPressed: () {
              state.driverDecline(request, user);
              showMessage(context, 'You declined ${request.id}.');
              Navigator.pop(context);
            },
          ),
        ];
      }
      if (status == RequestStatus.awaitingPassenger && request.driver == user.username) {
        return [const NoteBox(text: 'You accepted this request. Waiting for the passenger to accept you.')];
      }
      if (status == RequestStatus.confirmed && request.driver == user.username) {
        return [
          PrimaryButton(
            label: 'Mark trip as completed',
            icon: Icons.flag_circle_outlined,
            onPressed: () {
              state.completeTrip(request);
              showMessage(context, 'Trip ${request.id} marked as completed.');
            },
          ),
        ];
      }
    }
    return [];
  }

  Widget _cancelButton(BuildContext context, AppState state, TransportRequest request) {
    return SecondaryButton(
      label: 'Cancel request',
      icon: Icons.cancel_outlined,
      color: AppColors.red,
      onPressed: () async {
        final ok = await confirmAction(
          context,
          title: 'Cancel this request?',
          message: 'The driver will be told that you cancelled.',
          confirmLabel: 'Cancel request',
        );
        if (!ok || !context.mounted) return;
        state.cancelRequest(request);
        showMessage(context, 'Request ${request.id} cancelled.');
      },
    );
  }
}
