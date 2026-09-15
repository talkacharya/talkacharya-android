import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../core/astro/onboarding_store.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../shared/widgets/app_scaffold.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc b) => b.state.user);
    final profile = getIt<OnboardingStore>().profile;
    return AppScaffold(
      title: 'Profile',
      child: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: CircleAvatar(
              radius: 28,
              backgroundImage:
                  (user?.avatar != null && user!.avatar!.isNotEmpty)
                  ? NetworkImage(user.avatar!)
                  : null,
              child: (user?.avatar == null || user!.avatar!.isEmpty)
                  ? const Icon(Icons.person_rounded)
                  : null,
            ),
            title: Text(
              user?.shortName ?? '—',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            subtitle: Text(
              [
                if ((profile?.headline ?? '').isNotEmpty)
                  profile!.headline
                else
                  user?.phone ?? '',
                if ((profile?.followersCount ?? 0) > 0)
                  '${profile!.followersCount} followers',
              ].join(' · '),
            ),
            trailing: profile != null && profile.ratingCount > 0
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(profile.ratingAvg.toStringAsFixed(1)),
                      const Icon(Icons.star_rounded, size: 16),
                    ],
                  )
                : null,
          ),
          const Divider(),
          _row(context, Icons.edit_outlined, 'Edit profile', '/profile/edit'),
          _row(
            context,
            Icons.currency_rupee_rounded,
            'Rates',
            '/profile/rates',
          ),
          _row(
            context,
            Icons.schedule_rounded,
            'Availability & hours',
            '/profile/working-hours',
          ),
          _row(context, Icons.reviews_outlined, 'Reviews', '/profile/reviews'),
          _row(
            context,
            Icons.verified_user_outlined,
            'KYC & documents',
            '/profile/kyc',
          ),
          _row(
            context,
            Icons.star_border_rounded,
            'Featured slots',
            '/profile/featured',
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications_none_rounded),
            title: const Text('Notifications'),
            onTap: () => context.push('/notifications'),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.logout_rounded,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Log out',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () => _confirmLogout(context),
          ),
          const _AppVersion(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _row(BuildContext c, IconData icon, String title, String route) =>
      ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () => c.push(route),
      );

  Future<void> _confirmLogout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You will need to sign in again with an OTP.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if ((ok ?? false) && context.mounted) {
      context.read<AuthBloc>().add(const AuthLogoutRequested());
    }
  }
}

class _AppVersion extends StatelessWidget {
  const _AppVersion();
  @override
  Widget build(BuildContext context) => FutureBuilder<PackageInfo>(
    future: PackageInfo.fromPlatform(),
    builder: (context, snap) => Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Center(
        child: Text(
          snap.data == null
              ? ''
              : 'v${snap.data!.version} (${snap.data!.buildNumber})',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    ),
  );
}
