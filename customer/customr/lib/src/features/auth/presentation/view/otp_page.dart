import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/l10n/l10n.dart';
import '../bloc/login/login_cubit.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/primary_button.dart';
import 'widgets/resend_timer.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = context.brand;
    final defaultPin = PinTheme(
      width: 48,
      height: 54,
      textStyle: TextStyle(
        fontSize: 22,
        color: brand.ink,
        fontWeight: FontWeight.w700,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: brand.hairline),
      ),
    );
    final focusedPin = defaultPin.copyWith(
      decoration: defaultPin.decoration!.copyWith(
        border: Border.all(color: scheme.primary, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: scheme.primary.withValues(alpha: 0.18),
            blurRadius: 10,
          ),
        ],
      ),
    );
    final submittedPin = defaultPin.copyWith(
      decoration: defaultPin.decoration!.copyWith(
        border: Border.all(color: scheme.primary.withValues(alpha: 0.5)),
      ),
    );

    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (a, b) => a.error != b.error && b.error != null,
      listener: (context, state) {
        _controller.clear();
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(state.error!),
              behavior: SnackBarBehavior.floating,
            ),
          );
      },
      builder: (context, state) {
        if (state.devCode != null && _controller.text.isEmpty) {
          _controller.text = state.devCode!;
        }

        return AuthScaffold(
          title: context.l10n.authOtpTitle,
          subtitle: context.l10n.authOtpSubtitle(_prettyPhone(state.phone)),
          onBack: () => context.read<LoginCubit>().editPhone(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Pinput(
                  length: 6,
                  controller: _controller,
                  autofocus: true,
                  defaultPinTheme: defaultPin,
                  focusedPinTheme: focusedPin,
                  submittedPinTheme: submittedPin,
                  separatorBuilder: (_) => const SizedBox(width: 8),
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  onCompleted: (_) => _submit(context, state),
                  cursor: Container(
                    width: 2,
                    height: 22,
                    color: scheme.primary,
                  ),
                ),
              ),
              if (state.devCode != null) ...[
                const SizedBox(height: 14),
                _DevCodeHint(code: state.devCode!),
              ],
              const SizedBox(height: 24),
              PrimaryButton(
                label: context.l10n.authVerify,
                loading: state.submitting,
                onPressed: () => _submit(context, state),
              ),
              const SizedBox(height: 16),
              Center(
                child: ResendTimer(
                  enabled: !state.submitting,
                  resetToken:
                      state.challengeExpiresAt?.millisecondsSinceEpoch ?? 0,
                  onResend: () {
                    _controller.clear();
                    context.read<LoginCubit>().resendOtp();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _submit(BuildContext context, LoginState state) {
    if (state.submitting) return;
    FocusScope.of(context).unfocus();
    context.read<LoginCubit>().verifyOtp(_controller.text);
  }

  /// `+919565901765` -> `+91 95659 01765`
  static String _prettyPhone(String e164) {
    if (e164.startsWith('+91') && e164.length == 13) {
      final n = e164.substring(3);
      return '+91 ${n.substring(0, 5)} ${n.substring(5)}';
    }
    return e164;
  }
}

class _DevCodeHint extends StatelessWidget {
  const _DevCodeHint({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: scheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 16, color: scheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              context.l10n.authTestModeCode(code),
              style: TextStyle(color: context.brand.inkMuted, fontSize: 12.5),
            ),
          ),
        ],
      ),
    );
  }
}
