import 'package:flutter/material.dart';

/// Shown while [AuthBloc] resolves the stored session on cold start.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
