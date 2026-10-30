import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_preferences.dart';
import '../../core/app_routes.dart';
import '../../core/ui_helpers.dart';
import '../../data/fare_service.dart';
import '../../services/currency_service.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/fare_tile.dart';
import '../../widgets/place_picker_field.dart';
import '../../widgets/quantity_stepper.dart';
import '../../widgets/responsive_body.dart';

/// Form for requesting a ride: route, vehicle type, number of people and how
/// many extra seats to keep free. Shows the estimated fare as the form changes.
class RequestTransportScreen extends StatefulWidget {
  const RequestTransportScreen({super.key});

  @override
  State<RequestTransportScreen> createState() => _RequestTransportScreenState();
}

class _RequestTransportScreenState extends State<RequestTransportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  String? _pickup;
  String? _destination;
  String? _mode;
  int _people = 1;
  int _freeSeats = 0;
  late String _payCurrency = AppPreferences.instance.currency;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  int get _capacity => FareService.seatCapacity[_mode] ?? 1;
  bool get _perSeat => _mode != null && FareService.isPerPassenger(_mode!);

  void _onModeChanged(String? mode) {
    setState(() {
      _mode = mode;
      _people = 1;
      _freeSeats = 0;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final state = AppState.instance;
    final quote = state.quote(_mode!, _pickup!, _destination!);
    if (!quote.isAvailable) {
      showMessage(context, quote.unavailableReason ?? 'This option is not available', error: true);
      return;
    }
    final total = FareService.requestTotal(quote, _mode!, _people, _perSeat ? _freeSeats : 0);
    final request = state.createRequest(
      pickup: _pickup!,
      destination: _destination!,
      mode: _mode!,
      people: _people,
      freeSeats: _perSeat ? _freeSeats : 0,
      fareText: FareService.requestFareText(quote, _mode!, _people, _perSeat ? _freeSeats : 0),
      note: _noteController.text.trim(),
      payCurrency: _payCurrency,
      payAmount: total == null ? null : CurrencyService.amountIn(total, _payCurrency),
    );
    showMessage(context, 'Request ${request.id} sent. Waiting for a driver.');
    // Replace this form with the details screen of the new request.
    Navigator.pushReplacementNamed(context, AppRoutes.requestDetails, arguments: request.id);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final ready = _pickup != null && _destination != null && _pickup != _destination && _mode != null;
    final quote = ready ? state.quote(_mode!, _pickup!, _destination!) : null;
    final driverType = _mode == null ? null : FareService.driverTypeFor(_mode!);
    final drivers = driverType == null ? 0 : state.countVerifiedDrivers(driverType);

    return Scaffold(
      appBar: const AppTopBar(title: 'Request transportation'),
      body: SafeArea(
        child: ResponsiveBody(
          maxWidth: 560,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                  items: FareService.seatCapacity.keys.toList(),
                  onChanged: _onModeChanged,
                  validator: (v) => v == null ? 'Choose a transportation type' : null,
                ),
                if (_pickup != null && _pickup == _destination) ...[
                  const SizedBox(height: 12),
                  NoteBox(
                    text: 'Pickup and destination cannot be the same place.',
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.red,
                    background: AppColors.redTint,
                  ),
                ],
                if (_mode != null) ...[
                  const SectionTitle('Who is travelling?'),
                  QuantityStepper(
                    label: 'Number of people',
                    helper: '$_mode seats up to $_capacity (assumed)',
                    value: _people,
                    min: 1,
                    max: _capacity,
                    onChanged: (v) => setState(() {
                      _people = v;
                      if (_freeSeats > _capacity - _people) _freeSeats = _capacity - _people;
                    }),
                  ),
                  const SizedBox(height: 12),
                  if (_perSeat && _capacity - _people > 0)
                    QuantityStepper(
                      label: 'Extra seats to keep free',
                      helper: 'For more space. You pay for every seat you reserve.',
                      icon: Icons.event_seat_outlined,
                      value: _freeSeats,
                      min: 0,
                      max: _capacity - _people,
                      onChanged: (v) => setState(() => _freeSeats = v),
                    )
                  else if (!_perSeat)
                    const NoteBox(text: 'This is a private trip. The whole vehicle is yours for one fare.'),
                ],
                const SizedBox(height: 14),
                // A plain TextField (outside validation) for an optional note.
                TextField(
                  controller: _noteController,
                  maxLines: 2,
                  textInputAction: TextInputAction.done,
                  decoration: appInputDecoration('Note for the driver (optional)', Icons.sticky_note_2_outlined),
                ),
                if (quote != null) ...[
                  const SectionTitle('Estimated fare'),
                  _EstimateCard(
                    mode: _mode!,
                    quote: quote,
                    text: FareService.requestFareText(quote, _mode!, _people, _perSeat ? _freeSeats : 0),
                    other: CurrencyService.secondary(
                      FareService.requestTotal(quote, _mode!, _people, _perSeat ? _freeSeats : 0),
                      AppPreferences.instance.currency,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (quote.isAvailable) ...[
                    const SectionTitle('How will you pay?'),
                    AppDropdown(
                      label: 'Pay in',
                      icon: Icons.payments_outlined,
                      value: _payCurrency,
                      items: CurrencyService.acceptedPayments,
                      onChanged: (v) => setState(() => _payCurrency = v ?? 'NLe'),
                    ),
                    const SizedBox(height: 10),
                    _PaymentCard(
                      currency: _payCurrency,
                      total: FareService.requestTotal(quote, _mode!, _people, _perSeat ? _freeSeats : 0),
                    ),
                    const SizedBox(height: 10),
                  ],
                  if (quote.isAvailable && drivers == 0)
                    NoteBox(
                      text: 'No verified $driverType driver is registered yet. Your request will wait.',
                      icon: Icons.warning_amber_rounded,
                      color: AppColors.amber,
                      background: AppColors.amberTint,
                    )
                  else if (quote.isAvailable)
                    NoteBox(
                      text: '$drivers verified $driverType driver(s) can receive this request.',
                      icon: Icons.verified_outlined,
                      color: AppColors.success,
                      background: AppColors.successTint,
                    ),
                ],
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'Send request',
                  icon: Icons.send,
                  onPressed: (quote != null && !quote.isAvailable) ? null : _submit,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows what the passenger will pay in the chosen currency.
class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.currency, required this.total});

  final String currency;
  final double? total;

  @override
  Widget build(BuildContext context) {
    if (total == null) {
      return const NoteBox(text: 'This fare is agreed with the driver, so no amount can be shown yet.');
    }
    final amount = CurrencyService.amountIn(total!, currency);
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('You pay', style: TextStyle(color: AppColors.textSecondary)),
          Text(
            CurrencyService.money(amount, currency),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 6),
          Text(
            currency == 'NLe'
                ? 'Paid in leones.'
                : 'Recorded in $currency and not converted to leones by the app. Indicative rate: 1 $currency = NLe ${CurrencyService.rateFor(currency).toStringAsFixed(2)}.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.35),
          ),
          const SizedBox(height: 10),
          NoteBox(
            text: 'Prices are set in leones (NLe). This prototype takes no real payment. Accepting foreign currency in Sierra Leone must follow Bank of Sierra Leone rules.',
            icon: Icons.gavel,
            color: AppColors.amber,
            background: AppColors.amberTint,
          ),
        ],
      ),
    );
  }
}

class _EstimateCard extends StatelessWidget {
  const _EstimateCard({required this.mode, required this.quote, required this.text, this.other});

  final String mode;
  final FareQuote quote;
  final String text;
  final String? other;

  @override
  Widget build(BuildContext context) {
    if (!quote.isAvailable) {
      return NoteBox(
        text: '$mode: ${quote.unavailableReason}. Please choose another transportation type.',
        icon: Icons.block,
        color: AppColors.red,
        background: AppColors.redTint,
      );
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
          if (other != null) ...[
            const SizedBox(height: 4),
            Text('Total $other', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
          ],
          const SizedBox(height: 8),
          SourceTag(quote.source),
          if (quote.isSimulated) ...[
            const SizedBox(height: 8),
            Text(
              'This is a simulated estimate, not an official fare.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }
}
