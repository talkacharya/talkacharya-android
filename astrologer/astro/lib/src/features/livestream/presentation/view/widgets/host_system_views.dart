import 'package:flutter/material.dart';
import 'package:talkacharya_live/talkacharya_live.dart';

class PermissionView extends StatelessWidget {
  const PermissionView({
    required this.blocked,
    required this.onSettings,
    required this.onRetry,
    required this.onClose,
    super.key,
  });

  final bool blocked;
  final VoidCallback onSettings;
  final VoidCallback onRetry;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return HostSystemMessage(
      icon: Icons.videocam_off_rounded,
      title: 'Camera and microphone needed',
      body: blocked
          ? 'Camera or microphone access is turned off for TalkAcharya. Turn it '
                'on in Settings to go live.'
          : 'Allow camera and microphone access so your viewers can see and hear '
                'you.',
      primaryLabel: blocked ? 'Open settings' : 'Try again',
      onPrimary: blocked ? onSettings : onRetry,
      onClose: onClose,
    );
  }
}

class FailedView extends StatelessWidget {
  const FailedView({
    required this.message,
    required this.onRetry,
    required this.onClose,
    super.key,
  });

  final String? message;
  final VoidCallback onRetry;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return HostSystemMessage(
      icon: Icons.signal_wifi_bad_rounded,
      title: "Couldn't go live",
      body: message?.isNotEmpty == true
          ? message!
          : 'Check your connection and try again.',
      primaryLabel: 'Try again',
      onPrimary: onRetry,
      onClose: onClose,
    );
  }
}

class EndedView extends StatelessWidget {
  const EndedView({required this.state, required this.onClose, super.key});
  final LiveState state;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return HostSystemMessage(
      icon: Icons.check_circle_rounded,
      title: 'Session ended',
      body:
          'Peak ${state.viewerCount} watching. Your earnings from gifts appear '
          'under Earnings.',
      primaryLabel: 'Done',
      onPrimary: onClose,
      onClose: null,
    );
  }
}

class HostSystemMessage extends StatelessWidget {
  const HostSystemMessage({
    required this.icon,
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
    required this.onClose,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: Colors.white70),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, height: 1.4),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: onPrimary, child: Text(primaryLabel)),
            if (onClose != null)
              TextButton(
                onPressed: onClose,
                child: const Text(
                  'Close',
                  style: TextStyle(color: Colors.white70),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ConnectingView extends StatelessWidget {
  const ConnectingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.white),
          SizedBox(height: 24),
          Text(
            'Starting Live Session...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
