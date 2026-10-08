import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/astro/onboarding_store.dart';
import '../../../../core/config/config_repository.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../../training/data/training_api.dart';
import '../../data/kyc_status.dart';
import '../../data/onboarding_api.dart';
import '../widgets/kyc_documents.dart';
import '../widgets/onboarding_steps.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';

/// The screen a not-yet-approved astrologer sees, per [OnboardingStage]:
/// a step checklist, the under-review timeline, or a blocked state.
class OnboardingGatePage extends StatefulWidget {
  const OnboardingGatePage({super.key});

  @override
  State<OnboardingGatePage> createState() => _OnboardingGatePageState();
}

class _OnboardingGatePageState extends State<OnboardingGatePage> {
  final _store = getIt<OnboardingStore>();

  @override
  void initState() {
    super.initState();
    // Keep the status fresh while this screen is up (e.g. ops approves).
    _store.refresh();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: brand.cosmicStart,
        body: Stack(
          children: [
            const Positioned.fill(child: CosmicBackdrop()),
            SafeArea(
              child: ListenableBuilder(
                listenable: _store,
                builder: (context, _) {
                  final stage = _store.stage;
                  // Come back to from the lessons, with the gate now lifted.
                  if (stage == OnboardingStage.approved) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (context.mounted) context.go(Routes.home);
                    });
                  }
                  return RefreshIndicator(
                    onRefresh: _store.refresh,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                l.obTitle,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: brand.onCosmicMuted,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor: brand.onCosmicMuted,
                              ),
                              onPressed: () => context.read<AuthBloc>().add(
                                const AuthLogoutRequested(),
                              ),
                              icon: const Icon(Icons.logout_rounded, size: 18),
                              label: Text(l.profileLogout),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: switch (stage) {
                            OnboardingStage.wizard => _Checklist(
                              key: const ValueKey('wizard'),
                              store: _store,
                            ),
                            OnboardingStage.underReview => _UnderReview(
                              key: const ValueKey('review'),
                              store: _store,
                            ),
                            OnboardingStage.training => _TrainingGate(
                              key: const ValueKey('training'),
                              store: _store,
                            ),
                            OnboardingStage.suspended => _Blocked(
                              key: const ValueKey('suspended'),
                              icon: Icons.block_rounded,
                              title: l.obSuspendedTitle,
                              body: l.obSuspendedBody,
                            ),
                            OnboardingStage.notAstrologer => _Blocked(
                              key: const ValueKey('not'),
                              icon: Icons.person_off_rounded,
                              title: l.obNotAstroTitle,
                              body: l.obNotAstroBody,
                            ),
                            _ => const Padding(
                              key: ValueKey('loading'),
                              padding: EdgeInsets.only(top: 160),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Frosted panel used throughout the gate.
class _Glass extends StatelessWidget {
  const _Glass({required this.child, this.padding = const EdgeInsets.all(16)});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) => Container(
    padding: padding,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(Radii.lg),
      border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
    ),
    child: child,
  );
}

class _GoldButton extends StatelessWidget {
  const _GoldButton({required this.label, required this.onTap, this.icon});

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    const fg = Color(0xFF3A1703);
    return Pressable(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(Radii.md),
          child: Ink(
            height: 54,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Radii.md),
              gradient: const LinearGradient(colors: BrandColors.goldGradient),
              boxShadow: [
                BoxShadow(
                  color: BrandColors.goldGradient.last.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: fg,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 8),
                  Icon(icon, color: fg),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Checklist extends StatelessWidget {
  const _Checklist({required this.store, super.key});

  final OnboardingStore store;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final name = context.select((AuthBloc b) => b.state.user?.shortName ?? '');
    final gaps = store.gaps;
    final rejected = store.profile?.rejectionReason ?? '';
    final steps = OnboardingStep.values
        .where((s) => s != OnboardingStep.review)
        .toList();
    final done = steps.where((s) => s.isDone(gaps)).length;
    final started = done > 0 || rejected.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FadeSlideIn(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isEmpty ? l.wizTitle : l.obWelcome(name),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: brand.onCosmic,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l.obWelcomeBody,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: brand.onCosmicMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              _ProgressRing(done: done, total: steps.length),
            ],
          ),
        ),
        if (rejected.isNotEmpty) ...[
          const SizedBox(height: 16),
          FadeSlideIn(
            delay: const Duration(milliseconds: 60),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: brand.live.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(Radii.md),
                border: Border.all(color: brand.live.withValues(alpha: 0.4)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.error_outline_rounded, color: brand.live),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.obRejectedTitle,
                          style: TextStyle(
                            color: brand.onCosmic,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(rejected, style: TextStyle(color: brand.onCosmic)),
                        const SizedBox(height: 4),
                        Text(
                          l.obRejectedHint,
                          style: TextStyle(
                            color: brand.onCosmicMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        _Glass(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            children: [
              for (var i = 0; i < OnboardingStep.values.length; i++)
                FadeSlideIn(
                  delay: Duration(milliseconds: 80 + 50 * i),
                  child: _StepRow(
                    step: OnboardingStep.values[i],
                    done: OnboardingStep.values[i].isDone(gaps),
                    last: i == OnboardingStep.values.length - 1,
                    onTap: () => context.push(
                      '/onboarding/wizard?step=${OnboardingStep.values[i].name}',
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _GoldButton(
          label: started ? l.obContinue : l.obStart,
          icon: Icons.arrow_forward_rounded,
          onTap: () => context.push('/onboarding/wizard'),
        ),
      ],
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return SizedBox.square(
      dimension: 72,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: total == 0 ? 0 : done / total),
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              builder: (_, v, _) => CircularProgressIndicator(
                value: v,
                strokeWidth: 6,
                strokeCap: StrokeCap.round,
                color: brand.glowAccent,
                backgroundColor: Colors.white.withValues(alpha: 0.12),
              ),
            ),
          ),
          Text(
            '$done/$total',
            style: TextStyle(
              color: brand.onCosmic,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.step,
    required this.done,
    required this.last,
    required this.onTap,
  });

  final OnboardingStep step;
  final bool done;
  final bool last;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            if (done)
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: brand.online.withValues(alpha: 0.2),
                ),
                child: Icon(Icons.check_rounded, color: brand.online),
              )
            else
              HueIcon(hue: step.hue, icon: step.icon, size: 36, iconSize: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title(l),
                    style: TextStyle(
                      color: brand.onCosmic,
                      fontWeight: FontWeight.w700,
                      decoration: done ? TextDecoration.lineThrough : null,
                      decorationColor: brand.onCosmicMuted,
                    ),
                  ),
                  Text(
                    step.subtitle(l),
                    style: TextStyle(color: brand.onCosmicMuted, fontSize: 12),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: brand.onCosmicMuted),
          ],
        ),
      ),
    );
  }
}

/// The application while a reviewer has it: which stage it is at, anything
/// they sent back (fixed right here), and the interview once it has a time.
class _UnderReview extends StatefulWidget {
  const _UnderReview({required this.store, super.key});

  final OnboardingStore store;

  @override
  State<_UnderReview> createState() => _UnderReviewState();
}

class _UnderReviewState extends State<_UnderReview> {
  KycStatus? _status;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _load();
    // A reviewer's step usually arrives over the socket (the store refreshes
    // and we reload with it); this is for when the socket is not up.
    widget.store.addListener(_load);
    _poll = Timer.periodic(
      const Duration(seconds: 30),
      (_) => widget.store.refresh(),
    );
  }

  @override
  void dispose() {
    _poll?.cancel();
    widget.store.removeListener(_load);
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final status = await getIt<OnboardingApi>().kycStatus();
      if (mounted) setState(() => _status = status);
    } catch (_) {
      // Keep what is on screen; the next refresh tries again.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final status = _status;
    final stage = status?.stage ?? 'documents';
    final withInterview = status?.interviewRequired ?? true;
    // (label, done, current)
    final steps = [
      (l.obReviewSubmitted, true, false),
      (l.obStageDocuments, stage != 'documents', stage == 'documents'),
      if (withInterview)
        (l.obStageInterview, stage == 'decision', stage == 'interview'),
      (l.obStageDecision, false, stage == 'decision'),
      (l.obReviewLive, false, false),
    ];
    final toFix = status?.actionable ?? const <KycDocumentState>[];
    final bank = status?.bank;
    final interview = status?.interview;
    final needsFixing = toFix.isNotEmpty || (bank?.rejected ?? false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Center(
          child: _PulsingOrb(
            icon: needsFixing
                ? Icons.assignment_late_rounded
                : Icons.hourglass_top_rounded,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          needsFixing ? l.obFixTitle : l.obReviewTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: brand.onCosmic,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          needsFixing ? l.obFixBody : l.obReviewBody,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: brand.onCosmicMuted,
          ),
        ),
        const SizedBox(height: 24),
        if (needsFixing) ...[
          KycDocumentList(documents: toFix, editable: false, onUploaded: _load),
          if (bank != null && bank.rejected)
            SettingsCard(
              title: l.obBankFixTitle,
              subtitle: bank.note.isEmpty ? null : bank.note,
              icon: Icons.account_balance_rounded,
              hue: AstroPalette.air,
              child: BusyButton(
                label: l.obBankFix,
                icon: Icons.edit_rounded,
                onPressed: () async {
                  await context.push<void>(
                    '${Routes.onboarding}/wizard?step=bank',
                  );
                  await _load();
                },
              ),
            ),
          const SizedBox(height: 6),
        ],
        if (interview != null && (interview.scheduled || stage == 'interview'))
          _InterviewCard(interview: interview)
        else if (stage == 'interview')
          _Glass(
            child: Text(
              l.obInterviewWaiting,
              style: TextStyle(color: brand.onCosmic, height: 1.4),
            ),
          ),
        if (stage == 'interview' || (interview?.scheduled ?? false))
          const SizedBox(height: 16),
        _Glass(
          child: Column(
            children: [
              for (var i = 0; i < steps.length; i++)
                _TimelineRow(
                  label: steps[i].$1,
                  done: steps[i].$2,
                  current: steps[i].$3,
                  last: i == steps.length - 1,
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _Glass(
          child: Row(
            children: [
              const HueIcon(
                hue: AstroPalette.fire,
                icon: Icons.play_lesson_rounded,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l.trainWhileWaiting,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: brand.onCosmic,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      l.trainWhileWaitingBody,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: brand.onCosmicMuted,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => context.push(Routes.training),
                icon: Icon(Icons.arrow_forward_rounded, color: brand.onCosmic),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: brand.onCosmic,
            side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
            minimumSize: const Size.fromHeight(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Radii.md),
            ),
          ),
          onPressed: widget.store.refresh,
          icon: const Icon(Icons.refresh_rounded),
          label: Text(l.obCheckStatus),
        ),
        const SizedBox(height: 8),
        const _SupportButton(),
      ],
    );
  }
}

/// When the interview is and how it will reach them.
class _InterviewCard extends StatelessWidget {
  const _InterviewCard({required this.interview});

  final KycInterview interview;

  String _when(BuildContext context, DateTime at) {
    final l = context.l10n;
    final time = TimeOfDay.fromDateTime(at).format(context);
    final days = DateUtils.dateOnly(
      at,
    ).difference(DateUtils.dateOnly(DateTime.now())).inHours;
    if (days.abs() < 12) return l.obInterviewToday(time);
    if (days >= 12 && days < 36) return l.obInterviewTomorrow(time);
    return l.obInterviewOn(DateFormat('d MMM', l.localeName).format(at), time);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final at = interview.scheduledAt;
    final missed = interview.status == 'no_show';
    final how = switch (interview.mode) {
      'whatsapp' => l.obInterviewWhatsapp,
      'video_link' => l.obInterviewLink,
      _ => l.obInterviewPhone,
    };
    return _Glass(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.event_available_rounded, color: brand.gold),
              const SizedBox(width: 10),
              Text(
                l.obInterviewTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: brand.onCosmic,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (!interview.scheduled || at == null)
            Text(
              missed ? l.obInterviewMissed : l.obInterviewWaiting,
              style: TextStyle(color: brand.onCosmic, height: 1.4),
            )
          else ...[
            Text(
              l.obInterviewWhen(_when(context, at)),
              style: theme.textTheme.headlineSmall?.copyWith(
                color: brand.onCosmic,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              how,
              style: TextStyle(color: brand.onCosmicMuted, height: 1.4),
            ),
            if (interview.mode == 'video_link' &&
                interview.meetingLink.isNotEmpty) ...[
              const SizedBox(height: 12),
              _GoldButton(
                label: l.obInterviewJoin,
                icon: Icons.open_in_new_rounded,
                onTap: () => launchUrl(
                  Uri.parse(interview.meetingLink),
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.label,
    required this.done,
    required this.current,
    required this.last,
  });

  final String label;
  final bool done;
  final bool current;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final color = done
        ? brand.online
        : current
        ? brand.glowAccent
        : Colors.white.withValues(alpha: 0.3);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: done ? color : Colors.transparent,
                  border: Border.all(color: color, width: 2),
                ),
                child: done
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : current
                    ? Center(
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )
                    : null,
              ),
              if (!last)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    color: Colors.white.withValues(alpha: 0.15),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(top: 1, bottom: last ? 0 : 18),
              child: Text(
                label,
                style: TextStyle(
                  color: done || current ? brand.onCosmic : brand.onCosmicMuted,
                  fontWeight: current ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingOrb extends StatefulWidget {
  const _PulsingOrb({required this.icon});

  final IconData icon;

  @override
  State<_PulsingOrb> createState() => _PulsingOrbState();
}

class _PulsingOrbState extends State<_PulsingOrb>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final reduce = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    Widget orb(double t) => Container(
      width: 104,
      height: 104,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: BrandColors.goldGradient),
        boxShadow: [
          BoxShadow(
            color: brand.glowAccent.withValues(alpha: 0.25 + 0.3 * t),
            blurRadius: 24 + 20 * t,
            spreadRadius: 2 + 6 * t,
          ),
        ],
      ),
      child: Icon(widget.icon, size: 48, color: const Color(0xFF3A1703)),
    );
    if (reduce) return orb(0.5);
    return AnimatedBuilder(
      animation: _c,
      builder: (_, _) => orb(Curves.easeInOut.transform(_c.value)),
    );
  }
}

/// Approved, but the required lessons are not finished: the app stays shut
/// and this is the way to them.
class _TrainingGate extends StatefulWidget {
  const _TrainingGate({required this.store, super.key});

  final OnboardingStore store;

  @override
  State<_TrainingGate> createState() => _TrainingGateState();
}

class _TrainingGateState extends State<_TrainingGate> {
  TrainingStatus? _status;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final data = await getIt<TrainingApi>().load();
      if (mounted) setState(() => _status = data.status);
    } catch (_) {
      // The count is a nicety; the button works without it.
    }
  }

  Future<void> _open() async {
    await context.push<void>(Routes.training);
    await widget.store.refresh();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final s = _status;
    final total = s?.mandatoryTotal ?? 0;
    final done = s?.mandatoryDone ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        const Center(child: _PulsingOrb(icon: Icons.school_rounded)),
        const SizedBox(height: 24),
        Text(
          l.trainGateTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: brand.onCosmic,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l.trainGateBody,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: brand.onCosmicMuted,
          ),
        ),
        const SizedBox(height: 24),
        if (total > 0) ...[
          _Glass(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.trainHeroCount(done, total),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: brand.onCosmic,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: done / total,
                    minHeight: 7,
                    color: BrandColors.goldGradient.first,
                    backgroundColor: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
        _GoldButton(
          label: done > 0 ? l.trainGateContinue : l.trainGateStart,
          icon: Icons.play_arrow_rounded,
          onTap: _open,
        ),
        const SizedBox(height: 8),
        const _SupportButton(),
      ],
    );
  }
}

class _Blocked extends StatelessWidget {
  const _Blocked({
    required this.icon,
    required this.title,
    required this.body,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 48),
        Center(
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: brand.live.withValues(alpha: 0.18),
            ),
            child: Icon(icon, size: 44, color: brand.live),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: brand.onCosmic,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: brand.onCosmicMuted,
          ),
        ),
        const SizedBox(height: 28),
        const _SupportButton(primary: true),
      ],
    );
  }
}

/// Opens email (or WhatsApp) support from the remote config.
class _SupportButton extends StatelessWidget {
  const _SupportButton({this.primary = false});

  final bool primary;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final support = getIt<ConfigRepository>().value.support;
    final email = support.email.isNotEmpty
        ? support.email
        : 'support@talkacharya.com';
    void open() {
      final uri = support.email.isEmpty && support.whatsapp.isNotEmpty
          ? Uri.parse(
              'https://wa.me/${support.whatsapp.replaceAll(RegExp(r'\D'), '')}',
            )
          : Uri.parse('mailto:$email');
      launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    if (primary) {
      return _GoldButton(
        label: l.profileContact,
        icon: Icons.support_agent_rounded,
        onTap: open,
      );
    }
    return TextButton.icon(
      style: TextButton.styleFrom(foregroundColor: brand.onCosmicMuted),
      onPressed: open,
      icon: const Icon(Icons.support_agent_rounded),
      label: Text(l.profileContact),
    );
  }
}
