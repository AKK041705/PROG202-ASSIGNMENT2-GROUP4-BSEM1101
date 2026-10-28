import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/ui_helpers.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_card.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/responsive_body.dart';
import '../../widgets/status_chip.dart';

/// Administrator tab: verify new drivers and see the verified ones.
class AdminDriversView extends StatelessWidget {
  const AdminDriversView({super.key});

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    return ListenableBuilder(
      listenable: state,
      builder: (context, _) {
        final waiting = state.drivers.where((d) => !d.verified).toList();
        final verified = state.drivers.where((d) => d.verified).toList();
        return RefreshIndicator(
          color: AppColors.green,
          onRefresh: () async => state.refresh(),
          child: ResponsiveBody(
            scroll: false,
            child: ListView(
              children: [
                const SectionTitle('Waiting for verification'),
                if (waiting.isEmpty)
                  const NoteBox(text: 'No drivers are waiting for verification.'),
                for (final d in waiting) _DriverCard(driver: d, canVerify: true),
                const SectionTitle('Verified drivers'),
                for (final d in verified) _DriverCard(driver: d, canVerify: false),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DriverCard extends StatelessWidget {
  const _DriverCard({required this.driver, required this.canVerify});

  final AppUser driver;
  final bool canVerify;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(driver.name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
              ),
              StatusChip(
                label: driver.verified ? 'Verified' : 'Waiting',
                textColor: driver.verified ? AppColors.success : AppColors.amber,
                background: driver.verified ? AppColors.successTint : AppColors.amberTint,
              ),
            ],
          ),
          const SizedBox(height: 8),
          InfoRow('Type', driver.driverType ?? '-'),
          InfoRow('Vehicle', driver.vehicle ?? '-'),
          InfoRow('Plate', driver.plate ?? '-'),
          InfoRow('Phone', driver.phone),
          if (canVerify) ...[
            const SizedBox(height: 10),
            PrimaryButton(
              label: 'Verify driver',
              icon: Icons.verified_outlined,
              onPressed: () {
                AppState.instance.verifyDriver(driver);
                showMessage(context, '${driver.name} is now verified.');
              },
            ),
          ],
        ],
      ),
    );
  }
}
