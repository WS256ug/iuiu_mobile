import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/navigation/app_shell.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../data/campus_options.dart';
import 'forgot_password_screen.dart';
import 'widgets/authentication_scaffold.dart';

/// Displays the local sign-in UI before backend authentication is integrated.
class LoginScreen extends StatefulWidget {
  const LoginScreen({this.onSignedIn, super.key});

  final VoidCallback? onSignedIn;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// Stores form input and temporary visibility/validation state for sign-in.
class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _campus;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Validates the local form and enters the UI without contacting a server.
  void _signIn() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    if (widget.onSignedIn != null) {
      widget.onSignedIn!();
      return;
    }
    final navigator = Navigator.of(context);
    navigator.pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => AppShell(
          onLogout: () {
            navigator.pushAndRemoveUntil(
              MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
              (route) => false,
            );
          },
        ),
      ),
    );
  }

  /// Opens the recovery screen represented by the forgot-password link.
  void _openForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationScaffold(
      title: 'Welcome back',
      subtitle: 'Sign in to access your Academica ERP account.',
      child: AutofillGroup(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Registration number / Staff ID',
                style: AppTextStyles.fieldLabel,
              ),
              const SizedBox(height: 8),
              TextFormField(
                key: const ValueKey('identifier-field'),
                controller: _identifierController,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.username],
                decoration: _inputDecoration(
                  hintText: 'Enter registration number or staff ID',
                  icon: Icons.badge_outlined,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Enter your registration number or staff ID'
                    : null,
              ),
              const SizedBox(height: 16),
              const Text('Password', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 8),
              TextFormField(
                key: const ValueKey('password-field'),
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.password],
                onFieldSubmitted: (_) => _signIn(),
                decoration:
                    _inputDecoration(
                      hintText: 'Enter your password',
                      icon: Icons.lock_outline_rounded,
                    ).copyWith(
                      suffixIcon: IconButton(
                        key: const ValueKey('password-visibility-button'),
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        tooltip: _obscurePassword
                            ? 'Show password'
                            : 'Hide password',
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          size: 20,
                        ),
                      ),
                    ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your password'
                    : null,
              ),
              const SizedBox(height: 16),
              const Text('Campus', style: AppTextStyles.fieldLabel),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                key: const ValueKey('campus-field'),
                initialValue: _campus,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                decoration: _inputDecoration(
                  hintText: 'Select your campus',
                  icon: Icons.location_on_outlined,
                ),
                items: CampusOptions.all
                    .map(
                      (campus) =>
                          DropdownMenuItem(value: campus, child: Text(campus)),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _campus = value),
                validator: (value) =>
                    value == null ? 'Select your campus' : null,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  key: const ValueKey('forgot-password-button'),
                  onPressed: _openForgotPassword,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              FilledButton(
                key: const ValueKey('sign-in-button'),
                onPressed: _signIn,
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.smallRadius,
                    ),
                  ),
                ),
                child: const Text(
                  'SIGN IN',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .8,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              const Text(
                'For account assistance, contact your campus administrator.',
                textAlign: TextAlign.center,
                style: AppTextStyles.supporting,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Gives login fields the same border, spacing, icon, and label treatment.
InputDecoration _inputDecoration({
  required String hintText,
  required IconData icon,
}) {
  return InputDecoration(
    hintText: hintText,
    hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
    prefixIcon: Icon(icon, size: 20),
    filled: true,
    fillColor: AppColors.pageBackground,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.smallRadius),
      borderSide: const BorderSide(color: AppColors.divider),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppConstants.smallRadius),
      borderSide: const BorderSide(color: AppColors.divider),
    ),
  );
}
