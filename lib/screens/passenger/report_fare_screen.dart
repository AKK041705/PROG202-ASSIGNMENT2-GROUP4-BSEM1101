import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/ui_helpers.dart';
import '../../core/validators.dart';
import '../../data/fare_service.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/place_picker_field.dart';
import '../../widgets/responsive_body.dart';

class ReportFareScreen extends StatefulWidget {
  const ReportFareScreen({super.key});

  @override
  State<ReportFareScreen> createState() => _ReportFareScreenState();
}

class _ReportFareScreenState extends State<ReportFareScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  String? _pickup;
  String? _destination;
  String? _mode;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final state = AppState.instance;
    final quote = state.quote(_mode!, _pickup!, _destination!);
    final report = state.submitReport(
      from: _pickup!,
      to: _destination!,
      mode: _mode!,
      reported: double.parse(_amountController.text.trim()),
      note: _noteController.text,
      systemFare: quote.isAvailable && quote.amount != null
          ? '${FareService.money(quote.amount!)} [${quote.source}]'
          : 'No fixed fare in the system',
    );
    showMessage(context, 'Report ${report.id} sent. Status: Pending Review.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final amount = double.tryParse(_amountController.text.trim());
    final routeReady = _pickup != null && _destination != null && _pickup != _destination && _mode != null;
    final quote = routeReady ? state.quote(_mode!, _pickup!, _destination!) : null;

    return Scaffold(
      appBar: const AppTopBar(title: 'Report a fare issue'),
      body: SafeArea(
        child: ResponsiveBody(
          maxWidth: 560,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const NoteBox(
                  text: 'Use this when a driver asks for a fare that looks different from the fare in the app. '
                      'A report is a record for review. It is not a finding of fault.',
                ),
                const SizedBox(height: 16),
                PlacePickerField(
                  label: 'Pickup',
                  value: _pickup,
                  icon: Icons.trip_origin,
                  onChanged: (v) => setState(() => _pickup = v),
                ),
                const SizedBox(height: 14),
                PlacePickerField(
                  label: 'Destination',
                  value: _destination,
                  icon: Icons.flag_outlined,
                  onChanged: (v) => setState(() => _destination = v),
                ),
                const SizedBox(height: 14),
                AppDropdown(
                  label: 'Transportation type',
                  icon: Icons.directions_bus_outlined,
                  value: _mode,
                  items: FareService.fareModes,
                  onChanged: (v) => setState(() => _mode = v),
                  validator: (v) => v == null ? 'Choose a transportation type' : null,
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _amountController,
                  label: 'Fare you were asked to pay (NLe)',
                  icon: Icons.payments_outlined,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: Validators.amount,
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _noteController,
                  label: 'What happened? (optional)',
                  icon: Icons.notes,
                  maxLines: 3,
                  textInputAction: TextInputAction.done,
                ),
                if (quote != null) ...[
                  const SectionTitle('Fare in the system'),
                  _Comparison(quote: quote, reported: amount),
                ],
                const SizedBox(height: 20),
                PrimaryButton(label: 'Send report', icon: Icons.send, onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Comparison extends StatelessWidget {
  const _Comparison({required this.quote, required this.reported});

  final FareQuote quote;
  final double? reported;

  @override
  Widget build(BuildContext context) {
    if (!quote.isAvailable || quote.amount == null) {
      return const NoteBox(text: 'No fixed fare is available in the system to compare with.');
    }
    final listed = quote.amount!;
    String result = 'Enter the fare you were asked to pay to see the difference.';
    if (reported != null) {
      final diff = reported! - listed;
      if (diff > 0.05) {
        result = '${FareService.money(diff)} above the fare in the system.';
      } else if (diff < -0.05) {
        result = '${FareService.money(-diff)} below the fare in the system.';
      } else {
        result = 'The reported fare matches the fare in the system.';
      }
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(FareService.money(listed), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          Text(quote.source, style: TextStyle(color: AppColors.textSecondary)),
          const SizedBox(height: 10),
          Text(result, style: const TextStyle(fontWeight: FontWeight.w600)),
          if (quote.isSimulated) ...[
            const SizedBox(height: 6),
            Text(
              'The system fare is a simulated estimate, not an official fare.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}
