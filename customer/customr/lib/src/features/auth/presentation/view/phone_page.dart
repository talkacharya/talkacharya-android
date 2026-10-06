import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/l10n/l10n.dart';
import '../bloc/login/login_cubit.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/legal_consent.dart';
import 'widgets/phone_field.dart';
import 'widgets/primary_button.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final _controller = TextEditingController();

  /// The Terms and the Privacy Policy have been accepted. Asked for on every
  /// sign-in: nobody gets a code without it.
  bool _accepted = false;

  /// They tried to continue without accepting — point at the tick box.
  bool _nudge = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return AuthScaffold(
      title: l.authPhoneTitle,
      subtitle: l.authPhoneSubtitle,
      child: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (a, b) => a.error != b.error && b.error != null,
        listener: (context, state) => _say(context, state.error!),
        builder: (context, state) {
          final valid = _controller.text.length == 10;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.authPhoneHint,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: context.brand.inkMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              PhoneNumberField(
                controller: _controller,
                enabled: !state.submitting,
                onSubmit: valid ? () => _submit(context) : null,
              ),
              const SizedBox(height: 16),
              LegalConsent(
                accepted: _accepted,
                enabled: !state.submitting,
                highlight: _nudge,
                onChanged: (v) => setState(() {
                  _accepted = v;
                  _nudge = false;
                }),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: l.authGetOtp,
                loading: state.submitting,
                onPressed: valid ? () => _submit(context) : null,
              ),
            ],
          );
        },
      ),
    );
  }

  void _say(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    if (!_accepted) {
      setState(() => _nudge = true);
      _say(context, context.l10n.authAgreeRequired);
      return;
    }
    context.read<LoginCubit>().requestOtp(
      _controller.text,
      acceptedTerms: true,
    );
  }
}
