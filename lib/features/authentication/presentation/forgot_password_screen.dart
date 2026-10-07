import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'widgets/authentication_scaffold.dart';

/// Collects an email address for the future password-recovery service.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

/// Holds the typed email and switches to confirmation after local validation.
class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Checks the form before showing the recovery confirmation panel.
  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationScaffold(
      title: 'Forgot password?',
      subtitle:
          'Enter the email linked to your account and we’ll send you recovery instructions.',
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Email address', style: AppTextStyles.fieldLabel),
            const SizedBox(height: 8),
            TextFormField(
              key: const ValueKey('recovery-email-field'),
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              onFieldSubmitted: (_) => _submit(),
              decoration: _inputDecoration(
                hintText: 'name@example.com',
                icon: Icons.mail_outline_rounded,
              ),
              validator: (value) {
                final email = value?.trim() ?? '';
                if (email.isEmpty) return 'Enter your email address';
                if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
                  return 'Enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            FilledButton(
              key: const ValueKey('send-recovery-button'),
              onPressed: _submit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.smallRadius),
                ),
              ),
              child: const Text(
                'SEND RECOVERY LINK',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .7,
                ),
              ),
            ),
            if (_submitted) ...[
              const SizedBox(height: 16),
              const _RecoveryConfirmation(),
            ],
          ],
        ),
      ),
    );
  }
}

/// Explains the next recovery step after a valid email is submitted.
class _RecoveryConfirmation extends StatelessWidget {
  const _RecoveryConfirmation();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('recovery-confirmation'),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.pageBackground,
        borderRadius: BorderRadius.circular(AppConstants.smallRadius),
        border: Border.all(color: AppColors.primary.withValues(alpha: .2)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: AppColors.primary, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'If the email matches an account, recovery instructions will be sent.',
              style: TextStyle(fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

/// Gives recovery fields the same border, spacing, icon, and label treatment.
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
