import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../data/auth_repository.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/login/login_cubit.dart';
import 'otp_page.dart';
import 'phone_page.dart';

/// Owns the [LoginCubit] lifecycle and renders the current step.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        repo: GetIt.I<AuthRepository>(),
        authBloc: context.read<AuthBloc>(),
      ),
      child: BlocBuilder<LoginCubit, LoginState>(
        buildWhen: (a, b) => a.step != b.step,
        builder: (context, state) => AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: switch (state.step) {
            LoginStep.enterPhone => const PhonePage(key: ValueKey('phone')),
            LoginStep.enterOtp => const OtpPage(key: ValueKey('otp')),
          },
        ),
      ),
    );
  }
}
