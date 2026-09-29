import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/config/config_repository.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/l10n/l10n.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/theme/brand_colors.dart';
import '../../../../../shared/widgets/cosmic.dart';
import '../../../../../shared/widgets/fade_slide_in.dart';

/// The frame both sign-in steps sit in.
///
/// Sign-in is the one screen every astrologer sees before anything else, and
/// it was the only one the redesign never reached — a bare white form in an
/// app that is deep-space everywhere else. This is the same backdrop the
/// dashboard, onboarding and profile headers use, so the first impression
/// matches the app behind it.
///
/// Shared by both steps so the switch between them cross-fades the content
/// rather than the whole screen.
class AuthShell extends StatelessWidget {
  const AuthShell({required this.children, this.onBack, super.key});

  final List<Widget> children;

  /// Shown as a back arrow when there is a step to go back to.
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: brand.cosmicStart,
        // The form moves up with the keyboard instead of being overlapped.
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            const Positioned.fill(child: CosmicBackdrop()),
            SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    height: 48,
                    child: onBack == null
                        ? null
                        : Align(
                            alignment: Alignment.centerLeft,
                            child: IconButton(
                              onPressed: onBack,
                              color: brand.onCosmic,
                              icon: const Icon(Icons.arrow_back_rounded),
                            ),
                          ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                      child: Center(
                        // Tablets and foldables: a sign-in form stretched to
                        // 900px reads as a mistake.
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 440),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: children,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The app's mark, ringed so a square logo sits properly on the gradient.
class AuthLogo extends StatelessWidget {
  const AuthLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Center(
      child: Container(
        width: 84,
        height: 84,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: brand.onCosmic.withValues(alpha: .28)),
          boxShadow: [
            BoxShadow(
              color: brand.glowAccent.withValues(alpha: .45),
              blurRadius: 32,
              spreadRadius: 2,
            ),
          ],
        ),
        padding: const EdgeInsets.all(5),
        child: ClipOval(
          child: Image.asset(
            'assets/icon/logo.jpeg',
            fit: BoxFit.cover,
            // A missing asset should cost a logo, not the sign-in screen.
            errorBuilder: (_, _, _) => ColoredBox(
              color: brand.cosmicAccent,
              child: Icon(Icons.auto_awesome_rounded, color: brand.onCosmic),
            ),
          ),
        ),
      ),
    );
  }
}

/// A translucent panel for the form itself, so the fields read as a surface
/// against the gradient rather than floating on it.
class AuthCard extends StatelessWidget {
  const AuthCard({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: brand.onCosmic.withValues(alpha: .09),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: brand.onCosmic.withValues(alpha: .16)),
      ),
      child: child,
    );
  }
}

/// The explicit agreement, with both documents one tap away.
///
/// The old screen stated the terms as a fact of continuing, in grey text at
/// the bottom, and neither document was reachable from it. Someone signing up
/// to earn money through this app is entering a commercial agreement — so the
/// box is theirs to tick, and both policies open from here.
class AuthLegalGate extends StatefulWidget {
  const AuthLegalGate({
    required this.accepted,
    required this.onChanged,
    super.key,
  });

  final bool accepted;
  final ValueChanged<bool> onChanged;

  @override
  State<AuthLegalGate> createState() => _AuthLegalGateState();
}

class _AuthLegalGateState extends State<AuthLegalGate> {
  // Held rather than built inline: a gesture recogniser inside a TextSpan has
  // to be disposed, and one built during build never can be.
  final _terms = TapGestureRecognizer();
  final _privacy = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();
    final support = getIt<ConfigRepository>().value.support;
    _terms.onTap = () => _open(support.termsUrl);
    _privacy.onTap = () => _open(support.privacyUrl);
  }

  @override
  void dispose() {
    _terms.dispose();
    _privacy.dispose();
    super.dispose();
  }

  Future<void> _open(String url) async {
    if (!mounted) return;
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final uri = Uri.tryParse(url);
    if (url.isEmpty || uri == null) {
      messenger.showSnackBar(SnackBar(content: Text(l.authLegalUnavailable)));
      return;
    }
    try {
      final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!ok) {
        messenger.showSnackBar(SnackBar(content: Text(l.authLegalUnavailable)));
      }
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l.authLegalUnavailable)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);

    final body = theme.textTheme.bodySmall?.copyWith(
      color: brand.onCosmicMuted,
      height: 1.45,
    );
    final link = body?.copyWith(
      color: brand.onCosmic,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
      decorationColor: brand.onCosmic.withValues(alpha: .5),
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Slightly tighter than the default 48px target so the row reads as
        // one sentence with a box, not a settings toggle.
        SizedBox(
          width: 28,
          height: 28,
          child: Checkbox(
            value: widget.accepted,
            onChanged: (v) => widget.onChanged(v ?? false),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            side: BorderSide(
              color: brand.onCosmic.withValues(alpha: .6),
              width: 1.6,
            ),
            fillColor: WidgetStateProperty.resolveWith(
              (s) => s.contains(WidgetState.selected)
                  ? brand.cosmicAccent
                  : Colors.transparent,
            ),
            checkColor: brand.onCosmic,
          ),
        ),
        Gap.sm,
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text.rich(
              TextSpan(
                style: body,
                children: [
                  TextSpan(text: l.authLegalBefore),
                  TextSpan(
                    text: l.authLegalTerms,
                    style: link,
                    recognizer: _terms,
                  ),
                  TextSpan(text: l.authLegalBetween),
                  TextSpan(
                    text: l.authLegalPrivacy,
                    style: link,
                    recognizer: _privacy,
                  ),
                  TextSpan(text: l.authLegalAfter),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The step's primary action. Not [AppButton]: that one inherits the app's
/// light-surface `FilledButton` theme, which on this backdrop would be a pale
/// slab. Disabled here means "not yet", so it stays visible rather than
/// dropping to the theme's near-invisible disabled colour.
class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({
    required this.label,
    required this.loading,
    required this.onPressed,
    super.key,
  });

  final String label;
  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final enabled = onPressed != null && !loading;
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: enabled ? 1 : .45,
      child: FilledButton(
        onPressed: loading ? null : onPressed,
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(54),
          backgroundColor: brand.cosmicAccent,
          foregroundColor: brand.onCosmic,
          disabledBackgroundColor: brand.cosmicAccent,
          disabledForegroundColor: brand.onCosmic,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: loading
            ? SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: brand.onCosmic,
                ),
              )
            : Text(label),
      ),
    );
  }
}

/// The ten national digits of a stored number.
///
/// [LoginState.phone] is normalised to E.164 the moment it is submitted, so a
/// field that collects ten digits has to be given ten digits back — otherwise
/// going back to fix a typo refills it with "+9198…" and the length check
/// never passes again.
String nationalDigits(String stored) {
  final digits = stored.replaceAll(RegExp(r'\D'), '');
  return digits.length <= 10 ? digits : digits.substring(digits.length - 10);
}

/// "+91 98765 43210" — grouped, because a number shown back for confirmation
/// is checked digit by digit.
String prettyPhone(String stored) {
  final national = nationalDigits(stored);
  if (national.length != 10) return stored;
  return '+91 ${national.substring(0, 5)} ${national.substring(5)}';
}

/// The staggered entrance the rest of the app uses.
List<Widget> authStagger(List<Widget> children) => FadeSlideIn.list(
  children,
  step: const Duration(milliseconds: 70),
);
