import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_routes.dart';
import '../../core/session.dart';
import '../../core/ui_helpers.dart';
import '../../core/validators.dart';
import '../../models/models.dart';
import '../../state/app_state.dart';
import '../../widgets/app_buttons.dart';
import '../../widgets/app_card.dart';
import '../../widgets/app_text_field.dart';
import '../../widgets/app_top_bar.dart';
import '../../widgets/logo_widgets.dart';
import '../../widgets/responsive_body.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final user = AppState.instance.login(_usernameController.text, _passwordController.text);
    if (user == null) {
      showMessage(context, 'Wrong username or password', error: true);
      return;
    }
    Session.afterLogin(user);
    final route = switch (user.role) {
      UserRole.passenger => AppRoutes.passenger,
      UserRole.driver => AppRoutes.driver,
      UserRole.administrator => AppRoutes.admin,
    };
    // Replace the whole stack so Back cannot return to the login screen.
    Navigator.pushNamedAndRemoveUntil(context, route, (r) => false);
  }

  void _fillDemo(String username, String password) {
    setState(() {
      _usernameController.text = username;
      _passwordController.text = password;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppTopBar(title: 'Log in'),
      body: SafeArea(
        child: ResponsiveBody(
          maxWidth: 480,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(child: AppLogo(size: 84)),
                const SizedBox(height: 16),
                const Text(
                  'Welcome back',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 20),
                AppTextField(
                  controller: _usernameController,
                  label: 'Username',
                  icon: Icons.person_outline,
                  validator: (v) => Validators.required(v, 'Username'),
                ),
                const SizedBox(height: 14),
                AppTextField(
                  controller: _passwordController,
                  label: 'Password',
                  icon: Icons.lock_outline,
                  obscureText: _hidePassword,
                  textInputAction: TextInputAction.done,
                  validator: (v) => Validators.required(v, 'Password'),
                  onSubmitted: (_) => _submit(),
                  suffix: IconButton(
                    tooltip: _hidePassword ? 'Show password' : 'Hide password',
                    icon: Icon(_hidePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _hidePassword = !_hidePassword),
                  ),
                ),
                const SizedBox(height: 20),
                PrimaryButton(label: 'Log in', icon: Icons.login, onPressed: _submit),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.register),
                  child: const Text('No account yet? Create one'),
                ),
                const SizedBox(height: 12),
                AppCard(
                  color: AppColors.blueTint,
                  borderColor: AppColors.blueTint,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Demo accounts (tap to fill)',
                        style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.blue),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _DemoChip('Administrator', () => _fillDemo('admin', 'admin123')),
                          _DemoChip('Passenger Amina', () => _fillDemo('amina', '1234')),
                          _DemoChip('Passenger Mohamed', () => _fillDemo('mohamed', '1234')),
                          _DemoChip('Visitor Sarah (UK)', () => _fillDemo('sarah', '1234')),
                          _DemoChip('Okada rider', () => _fillDemo('rider1', '1234')),
                          _DemoChip('Kekeh rider', () => _fillDemo('kekeh1', '1234')),
                          _DemoChip('Taxi driver 1', () => _fillDemo('taxi1', '1234')),
                          _DemoChip('Taxi driver 2', () => _fillDemo('taxi2', '1234')),
                          _DemoChip('Bus driver', () => _fillDemo('bus1', '1234')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Demo accounts and demo data are fictional. You can also create your own passenger account.',
                        style: TextStyle(color: AppColors.blue, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoChip extends StatelessWidget {
  const _DemoChip(this.label, this.onTap);

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label, style: TextStyle(color: AppColors.blue, fontWeight: FontWeight.w600)),
      backgroundColor: AppColors.surface,
      side: BorderSide(color: AppColors.blue),
      onPressed: onTap,
    );
  }
}
