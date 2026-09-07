import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/app_button.dart';
import '../bloc/login/login_cubit.dart';

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
    final theme = Theme.of(context);
    return BlocConsumer<LoginCubit, LoginState>(
      listenWhen: (a, b) => a.error != b.error && b.error != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.error!)));
      },
      builder: (context, state) {
        // prefill for dev-mode convenience
        if (state.devCode != null && _controller.text.isEmpty) {
          _controller.text = state.devCode!;
        }
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: () => context.read<LoginCubit>().editPhone(),
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter the code',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Gap.sm,
                  Text(
                    'Sent to ${state.phone}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Gap.xl,
                  TextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    autofocus: true,
                    style: const TextStyle(fontSize: 28, letterSpacing: 12),
                    textAlign: TextAlign.center,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      counterText: '',
                      hintText: '••••••',
                    ),
                    onChanged: (v) {
                      if (v.length == 6) _submit(context, state);
                    },
                  ),
                  if (state.devCode != null) ...[
                    Gap.sm,
                    _DevCodeBanner(code: state.devCode!),
                  ],
                  Gap.lg,
                  AppButton(
                    label: 'Verify',
                    loading: state.submitting,
                    onPressed: () => _submit(context, state),
                  ),
                  Gap.md,
                  Center(
                    child: TextButton(
                      onPressed: state.submitting
                          ? null
                          : () => context.read<LoginCubit>().resendOtp(),
                      child: const Text('Resend code'),
                    ),
                  ),
                ],
              ),
            ),
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
}

class _DevCodeBanner extends StatelessWidget {
  const _DevCodeBanner({required this.code});
  final String code;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: scheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.build_circle_outlined,
            size: 18,
            color: scheme.onTertiaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Dev mode — code is $code',
              style: TextStyle(color: scheme.onTertiaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}
