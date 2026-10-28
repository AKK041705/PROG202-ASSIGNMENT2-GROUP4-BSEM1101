import 'package:flutter/material.dart';

import '../../core/ui_helpers.dart';
import '../../core/validators.dart';
import '../../data/fare_service.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/place_picker_field.dart';
import '../../widgets/responsive_body.dart';

/// Add a route fare, or change an existing one (the Tariff is passed in).
class FareEditScreen extends StatefulWidget {
  const FareEditScreen({super.key, this.tariff});

  final Tariff? tariff;

  @override
  State<FareEditScreen> createState() => _FareEditScreenState();
}

class _FareEditScreenState extends State<FareEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late String _mode;
  String? _from;
  String? _to;

  bool get _editing => widget.tariff != null;

  @override
  void initState() {
    super.initState();
    final t = widget.tariff;
    _mode = t?.mode ?? 'Bus';
    _from = t?.from;
    _to = t?.to;
    _amountController = TextEditingController(text: t?.fare?.toStringAsFixed(1) ?? '');
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_from == _to) {
      showMessage(context, 'From and To cannot be the same place', error: true);
      return;
    }
    if (_mode == 'Kekeh') {
      final a = FareService.placeByName(_from);
      final b = FareService.placeByName(_to);
      if (a == null || b == null || !a.isWesternArea || !b.isWesternArea) {
        showMessage(context, 'Kekeh do not run in the provinces. Fare not saved.', error: true);
        return;
      }
    }
    final amount = double.parse(_amountController.text.trim());
    AppState.instance.upsertTariff(
      mode: _mode,
      from: _from!,
      to: _to!,
      fare: amount,
      existing: widget.tariff,
    );
    showMessage(context, 'Fare saved. Passengers have been notified.');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: _editing ? 'Edit fare' : 'Add fare'),
      body: SafeArea(
        child: ResponsiveBody(
          maxWidth: 520,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const NoteBox(
                  text: 'Only enter fares supplied by the relevant authorities. '
                      'Passengers are notified when a fare changes.',
                ),
                const SizedBox(height: 16),
                AppDropdown(
                  label: 'Transport mode',
                  icon: Icons.directions_bus_outlined,
                  value: _mode,
                  items: FareService.adminFareModes,
                  onChanged: _editing ? (_) {} : (v) => setState(() => _mode = v ?? _mode),
                ),
                const SizedBox(height: 14),
                PlacePickerField(
                  label: 'From',
                  value: _from,
                  icon: Icons.trip_origin,
                  onChanged: (v) => setState(() => _from = v),
                ),
                const SizedBox(height: 14),
                PlacePickerField(
                  label: 'To',
                  value: _to,
                  icon: Icons.flag_outlined,
                  onChanged: (v) => setState(() => _to = v),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _amountController,
                  label: 'Fare (NLe)',
                  icon: Icons.payments_outlined,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.done,
                  validator: Validators.amount,
                ),
                const SizedBox(height: 20),
                PrimaryButton(label: 'Save fare', icon: Icons.save_outlined, onPressed: _save),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
