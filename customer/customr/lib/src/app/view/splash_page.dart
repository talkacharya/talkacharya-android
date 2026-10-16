import 'package:flutter/material.dart';

/// Shown while [AuthBloc] resolves the stored session on cold start.
/// Renders a centered logo with rounded corners on a clean canvas,
/// matching the brand's splash presentation.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFFF0E6DF),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8C4A1A).withValues(alpha: 0.12),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: Image.asset(
              'assets/icons/logo.jpeg',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFF8C4A1A),
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
