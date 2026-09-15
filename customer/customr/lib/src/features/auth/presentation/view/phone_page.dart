import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/l10n/l10n.dart';
import '../bloc/login/login_cubit.dart';
import 'widgets/auth_scaffold.dart';
import 'widgets/phone_field.dart';
import 'widgets/primary_button.dart';

class PhonePage extends StatefulWidget {
  const PhonePage({super.key});

  @override
  State<PhonePage> createState() => _PhonePageState();
}

class _PhonePageState extends State<PhonePage> {
  final _controller = TextEditingController();

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
    return AuthScaffold(
      title: l.authPhoneTitle,
      subtitle: l.authPhoneSubtitle,
      child: BlocConsumer<LoginCubit, LoginState>(
        listenWhen: (a, b) => a.error != b.error && b.error != null,
        listener: (context, state) {
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
          final valid = _controller.text.length == 10;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.authPhoneHint,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              PhoneNumberField(
                controller: _controller,
                enabled: !state.submitting,
                onSubmit: valid ? () => _submit(context) : null,
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: l.authGetOtp,
                loading: state.submitting,
                onPressed: valid ? () => _submit(context) : null,
              ),
              const SizedBox(height: 16),
              Text(
                l.authTermsNotice,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();
    context.read<LoginCubit>().requestOtp(_controller.text);
  }
}
