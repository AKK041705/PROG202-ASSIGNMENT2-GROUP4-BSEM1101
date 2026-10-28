import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../core/ui_helpers.dart';
import '../../core/validators.dart';
import '../../data/fare_service.dart';
import '../../models/models.dart';
import '../../services/currency_service.dart';
import '../../services/phone_service.dart';
import '../../state/app_state.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/responsive_body.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _vehicleController = TextEditingController();
  final _plateController = TextEditingController();

  String _role = 'Passenger';
  String? _driverType;
  bool _hidePassword = true;

  bool get _isDriver => _role == 'Driver';

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _vehicleController.dispose();
    _plateController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    AppState.instance.register(
      role: _isDriver ? UserRole.driver : UserRole.passenger,
      name: _nameController.text,
      username: _usernameController.text,
      password: _passwordController.text,
      phone: _phoneController.text,
      driverType: _isDriver ? _driverType : null,
      vehicle: _isDriver ? _vehicleController.text : null,
      plate: _isDriver ? _plateController.text : null,
    );
    showMessage(
      context,
      _isDriver
          ? 'Account created. The administrator must verify you before you receive requests.'
          : 'Account created. You can log in now.',
    );
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  /// Shows the country found from the calling code, and the currency for prices.
  Widget _countryNote() {
    final result = PhoneService.parse(_phoneController.text);
    if (!result.isValid) return const SizedBox.shrink();
    final country = result.country;
    final String text;
    if (country == null) {
      text = 'Country not recognised from the code. Prices will also be shown in USD.';
    } else if (country.isSierraLeone) {
      text = 'Detected: Sierra Leone (+232). Prices are shown in NLe.';
    } else {
      text = 'Detected: ${country.name} (+${country.dialCode}). Prices will also be shown in '
          '${country.currency}, for example NLe 12.0 is ${CurrencyService.secondary(12.0, country.currency)}.';
    }
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: NoteBox(
        text: text,
        icon: Icons.public,
        color: AppColors.success,
        background: AppColors.successTint,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Create account'),
      body: SafeArea(
        child: ResponsiveBody(
          maxWidth: 480,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppDropdown(
                  label: 'I am a',
                  icon: Icons.badge_outlined,
                  value: _role,
                  items: const ['Passenger', 'Driver'],
                  onChanged: (v) => setState(() => _role = v ?? 'Passenger'),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _nameController,
                  label: 'Full name',
                  icon: Icons.person_outline,
                  validator: (v) => Validators.required(v, 'Full name'),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _usernameController,
                  label: 'Username',
                  icon: Icons.alternate_email,
                  validator: (v) {
                    final basic = Validators.username(v);
                    if (basic != null) return basic;
                    if (AppState.instance.usernameTaken(v!)) return 'That username is already taken';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _phoneController,
                  label: 'Phone number',
                  icon: Icons.phone_outlined,
                  hint: '076 123 456 or +44 7700 900123',
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onChanged: (_) => setState(() {}),
                ),
                _countryNote(),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: _hidePassword,
                  validator: Validators.password,
                  suffix: IconButton(
                    tooltip: _hidePassword ? 'Show password' : 'Hide password',
                    icon: Icon(_hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _hidePassword = !_hidePassword),
                  ),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _confirmController,
                  label: 'Confirm password',
                  icon: Icons.lock_reset,
                  obscureText: _hidePassword,
                  textInputAction: _isDriver ? TextInputAction.next : TextInputAction.done,
                  validator: (v) => v != _passwordController.text ? 'Passwords do not match' : null,
                ),
                if (_isDriver) ...[
                  const SectionTitle('Vehicle details'),
                  AppDropdown(
                    label: 'Transportation type',
                    icon: Icons.directions_bus_outlined,
                    value: _driverType,
                    items: FareService.driverTypes,
                    onChanged: (v) => setState(() => _driverType = v),
                    validator: (v) => v == null ? 'Choose a transportation type' : null,
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: _vehicleController,
                    label: 'Vehicle description',
                    icon: Icons.directions_car_outlined,
                    hint: 'e.g. Toyota saloon',
                    validator: (v) => Validators.required(v, 'Vehicle description'),
                  ),
                  const SizedBox(height: 14),
                  AppTextField(
                    controller: _plateController,
                    label: 'Plate number',
                    icon: Icons.pin_outlined,
                    textInputAction: TextInputAction.done,
                    validator: (v) => Validators.required(v, 'Plate number'),
                  ),
                  const SizedBox(height: 14),
                  const NoteBox(
                    text: 'The administrator must verify your account before you can receive transport requests.',
                  ),
                ],
                const SizedBox(height: 20),
                PrimaryButton(label: 'Create account', icon: Icons.person_add_alt_1, onPressed: _submit),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                  child: const Text('Already have an account? Log in'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
