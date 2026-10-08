import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/session_end.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/login/login_cubit.dart';
import 'widgets/auth_shell.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// Step one: the number.
class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  static const _digits = 10;

  final _controller = TextEditingController();
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = nationalDigits(context.read<LoginCubit>().state.phone);
    // Redraws the Continue button as the number becomes complete.
    _controller.addListener(_onTyped);

    // Signed out because the account was used on another phone: say so.
    if (sessionEndReason.value == kSessionReplaced) {
      sessionEndReason.value = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.authSessionReplaced),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 6),
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTyped)
      ..dispose();
    _focus.dispose();
    super.dispose();
  }

  void _onTyped() => setState(() {});

  bool get _complete => _controller.text.length == _digits;

  void _submit(LoginState state) {
    if (state.submitting || !_complete || !state.termsAccepted) return;
    _focus.unfocus();
    context.read<LoginCubit>().requestOtp(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);

    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (a, b) => a.error != b.error && b.error != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.error!)));
      },
      builder: (context, state) {
        // Both conditions are visible on screen — the field shows how many
        // digits are left and the box is either ticked or it isn't — so the
        // button simply reflects them rather than failing after a tap.
        final ready = _complete && state.termsAccepted && !state.submitting;
        return AuthShell(
          children: authStagger([
            const SizedBox(height: 24),
            const AuthLogo(),
            Gap.lg,
            Text(
              l.authTitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: brand.onCosmic,
                fontWeight: FontWeight.w700,
              ),
            ),
            Gap.sm,
            Text(
              l.authSubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: brand.onCosmicMuted,
                height: 1.45,
              ),
            ),
            Gap.xl,
            AuthCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.authPhoneLabel,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: brand.onCosmicMuted,
                      letterSpacing: .3,
                    ),
                  ),
                  Gap.sm,
                  _PhoneField(
                    controller: _controller,
                    focusNode: _focus,
                    maxLength: _digits,
                    onSubmitted: () => _submit(state),
                  ),
                ],
              ),
            ),
            Gap.md,
            AuthLegalGate(
              accepted: state.termsAccepted,
              onChanged: context.read<LoginCubit>().acceptTerms,
            ),
            Gap.lg,
            AuthPrimaryButton(
              label: l.authContinue,
              loading: state.submitting,
              onPressed: ready ? () => _submit(state) : null,
            ),
            Gap.lg,
            // There is no separate sign-up: a new number entered here starts
            // an application. Without this, the screen reads as "members only".
            const _JoinCard(),
          ]),
        );
      },
    );
  }
}

/// "New here?" — what joining takes, in four steps, for an astrologer who
/// does not have an account yet.
class _JoinCard extends StatelessWidget {
  const _JoinCard();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final steps = [
      (Icons.phone_iphone_rounded, l.authJoinStep1),
      (Icons.badge_rounded, l.authJoinStep2),
      (Icons.fact_check_rounded, l.authJoinStep3),
      (Icons.verified_rounded, l.authJoinStep4),
    ];
    return AuthCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome_rounded, size: 18, color: brand.gold),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l.authJoinTitle,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: brand.onCosmic,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            l.authJoinBody,
            style: theme.textTheme.bodySmall?.copyWith(
              color: brand.onCosmicMuted,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          for (final (i, (icon, text)) in steps.indexed)
            Padding(
              padding: EdgeInsets.only(bottom: i == steps.length - 1 ? 0 : 10),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.10),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.16),
                      ),
                    ),
                    child: Icon(icon, size: 15, color: brand.onCosmic),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      text,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: brand.onCosmic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// The number itself: a fixed country prefix and ten digits, sized so it is
/// the obvious thing on the screen.
class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.controller,
    required this.focusNode,
    required this.maxLength,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final int maxLength;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    final number = theme.textTheme.titleLarge?.copyWith(
      color: brand.onCosmic,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
    );
    return Row(
      children: [
        Text('+91', style: number?.copyWith(color: brand.onCosmicMuted)),
        Container(
          width: 1,
          height: 26,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          color: brand.onCosmic.withValues(alpha: .22),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.phone,
            maxLength: maxLength,
            autofocus: true,
            style: number,
            cursorColor: brand.onCosmic,
            autofillHints: const [AutofillHints.telephoneNumberNational],
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: '',
              isDense: true,
              // The app's input theme fills every field with a pale surface
              // colour — which inside this glass card is an opaque grey slab.
              filled: false,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintText: context.l10n.authPhoneHint,
              // Deliberately not the number's own style: at that size and
              // letter-spacing the hint is wider than the field and truncates
              // to "10-digit num…".
              hintStyle: theme.textTheme.bodyLarge?.copyWith(
                color: brand.onCosmic.withValues(alpha: .38),
              ),
            ),
            onSubmitted: (_) => onSubmitted(),
          ),
        ),
      ],
    );
  }
}
