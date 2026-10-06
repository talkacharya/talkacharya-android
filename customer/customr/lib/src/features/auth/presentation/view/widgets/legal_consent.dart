import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/config/config_repository.dart';
import '../../../../../core/l10n/l10n.dart';

/// Where the documents live when the server has not said otherwise.
const _fallbackTerms = 'https://talkacharya.com/terms';
const _fallbackPrivacy = 'https://talkacharya.com/privacy';

/// "I agree to the Terms of Use and Privacy Policy", as a tick box whose two
/// document names open the documents. Signing in asks for this first.
class LegalConsent extends StatefulWidget {
  const LegalConsent({
    required this.accepted,
    required this.onChanged,
    this.enabled = true,
    this.highlight = false,
    super.key,
  });

  final bool accepted;
  final ValueChanged<bool> onChanged;
  final bool enabled;

  /// Draw attention to the box: they tried to continue without ticking it.
  final bool highlight;

  @override
  State<LegalConsent> createState() => _LegalConsentState();
}

class _LegalConsentState extends State<LegalConsent> {
  late final _terms = TapGestureRecognizer()..onTap = () => _open(_termsUrl);
  late final _privacy = TapGestureRecognizer()
    ..onTap = () => _open(_privacyUrl);

  String get _termsUrl {
    final url = GetIt.I<ConfigRepository>().value.support.termsUrl;
    return url.isEmpty ? _fallbackTerms : url;
  }

  String get _privacyUrl {
    final url = GetIt.I<ConfigRepository>().value.support.privacyUrl;
    return url.isEmpty ? _fallbackPrivacy : url;
  }

  Future<void> _open(String url) async {
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  void dispose() {
    _terms.dispose();
    _privacy.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final brand = context.brand;
    final warn = widget.highlight && !widget.accepted;
    final base = theme.textTheme.bodySmall?.copyWith(
      color: warn ? scheme.error : brand.inkMuted,
      height: 1.45,
    );
    final link = base?.copyWith(
      color: scheme.primary,
      fontWeight: FontWeight.w700,
      decoration: TextDecoration.underline,
      decorationColor: scheme.primary,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 28,
          height: 28,
          child: Checkbox(
            value: widget.accepted,
            onChanged: widget.enabled
                ? (v) => widget.onChanged(v ?? false)
                : null,
            isError: warn,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: widget.enabled
                ? () => widget.onChanged(!widget.accepted)
                : null,
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text.rich(
                TextSpan(
                  style: base,
                  children: [
                    TextSpan(text: l.authAgreeLead),
                    TextSpan(
                      text: l.authTermsLink,
                      style: link,
                      recognizer: _terms,
                    ),
                    TextSpan(text: l.authAgreeAnd),
                    TextSpan(
                      text: l.authPrivacyLink,
                      style: link,
                      recognizer: _privacy,
                    ),
                    TextSpan(text: l.authAgreeTrail),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
