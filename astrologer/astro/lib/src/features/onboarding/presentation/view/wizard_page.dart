import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../profile/data/profile_api.dart';
import '../../../profile/data/profile_models.dart';
import '../../../profile/presentation/view/kyc_page.dart'
    show kIfscPattern, kPanPattern;
import '../cubit/onboarding_cubit.dart';
import '../widgets/onboarding_steps.dart';
import '../../../../core/utils/haptic_service.dart';

/// Guided onboarding: Profile → Expertise → Identity → Bank → Review.
/// Completion is driven by the backend's `onboarding_gaps`; the wizard opens
/// on [initialStep] (an [OnboardingStep] name) or the first unfinished step.
class WizardPage extends StatelessWidget {
  const WizardPage({this.initialStep, super.key});

  final String? initialStep;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OnboardingCubit>()..load(),
      child: _WizardView(initialStep: initialStep),
    );
  }
}

class _WizardView extends StatefulWidget {
  const _WizardView({this.initialStep});

  final String? initialStep;

  @override
  State<_WizardView> createState() => _WizardViewState();
}

class _WizardViewState extends State<_WizardView> {
  OnboardingStep? _step;
  bool _prefilled = false;

  final _profileForm = GlobalKey<FormState>();
  final _panForm = GlobalKey<FormState>();
  final _bankForm = GlobalKey<FormState>();

  final _headline = TextEditingController();
  final _bio = TextEditingController();
  int _years = 0;
  final _pan = TextEditingController();
  final _holder = TextEditingController();
  final _account = TextEditingController();
  final _accountConfirm = TextEditingController();
  final _ifsc = TextEditingController();
  final _bankName = TextEditingController();

  final _skills = <String>{};
  final _langs = <String>{};
  String? _primary;
  List<RefOption> _skillOptions = const [];
  List<RefOption> _langOptions = const [];

  Uint8List? _photo;
  bool _replacePan = false;
  bool _replacePhoto = false;
  bool _editBank = false;

  @override
  void initState() {
    super.initState();
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    final api = getIt<ProfileApi>();
    try {
      final r = await Future.wait([api.skillOptions(), api.languageOptions()]);
      if (mounted) {
        setState(() {
          _skillOptions = r[0];
          _langOptions = r[1];
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    for (final c in [
      _headline,
      _bio,
      _pan,
      _holder,
      _account,
      _accountConfirm,
      _ifsc,
      _bankName,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  /// Seeds the form once, the first time the profile is available.
  void _prefill(OnboardingState state) {
    final p = state.profile;
    if (p == null || _prefilled) return;
    _prefilled = true;
    _headline.text = p.headline;
    _bio.text = p.bio;
    _years = p.yearsExperience;
    _skills.addAll(p.skills.map((s) => s.slug));
    _langs.addAll(p.languages);
    _primary = p.skills.where((s) => s.isPrimary).firstOrNull?.slug;
    _step =
        OnboardingStep.values
            .where((s) => s.name == widget.initialStep)
            .firstOrNull ??
        OnboardingStep.firstOpen(p.gaps);
  }

  void _go(OnboardingStep step) {
    FocusScope.of(context).unfocus();
    setState(() => _step = step);
  }

  Future<void> _continue() async {
    final l = context.l10n;
    final cubit = context.read<OnboardingCubit>();
    final step = _step!;
    var ok = true;
    switch (step) {
      case OnboardingStep.profile:
        if (!_profileForm.currentState!.validate()) return;
        ok = await cubit.saveProfile(
          headline: _headline.text.trim(),
          bio: _bio.text.trim(),
          yearsExperience: _years,
        );
      case OnboardingStep.expertise:
        if (_skills.isEmpty || _langs.isEmpty) {
          showToast(
            context,
            _skills.isEmpty ? l.wizPickSkill : l.wizPickLanguage,
          );
          return;
        }
        ok = await cubit.saveProfile(
          skillSlugs: _skills.toList(),
          primarySkillSlug: _skills.contains(_primary)
              ? _primary
              : _skills.first,
          languageCodes: _langs.toList(),
        );
      case OnboardingStep.identity:
        final needPan = cubit.state.gaps.contains('kyc:pan') || _replacePan;
        if (needPan) {
          if (!_panForm.currentState!.validate()) return;
          ok = await cubit.uploadKyc(docType: 'pan', number: _pan.text.trim());
          if (ok) _replacePan = false;
        }
        if (ok && cubit.state.gaps.contains('kyc:photo')) {
          if (mounted) showToast(context, l.wizPhotoRequired);
          return;
        }
      case OnboardingStep.bank:
        if (cubit.state.gaps.contains('bank_account') || _editBank) {
          if (!_bankForm.currentState!.validate()) return;
          ok = await cubit.saveBank(
            holder: _holder.text.trim(),
            accountNumber: _account.text.trim(),
            ifsc: _ifsc.text.trim(),
            bankName: _bankName.text.trim(),
          );
          if (ok) {
            _editBank = false;
            _account.clear();
            _accountConfirm.clear();
          }
        }
      case OnboardingStep.review:
        if (await cubit.submit() && mounted) {
          showToast(context, l.wizSubmitted);
          context.go(Routes.onboarding);
        }
        return;
    }
    if (ok && mounted) {
      _go(OnboardingStep.values[step.index + 1]);
    }
  }

  Future<void> _pickPhoto() async {
    final cubit = context.read<OnboardingCubit>();
    final x = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      imageQuality: 88,
    );
    if (x == null || !mounted) return;
    final bytes = await x.readAsBytes();
    setState(() => _photo = bytes);
    final ok = await cubit.uploadKyc(
      docType: 'photo',
      file: (bytes: bytes, filename: x.name),
    );
    if (mounted) setState(() => _replacePhoto = !ok);
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listenWhen: (a, b) => b.error != null && a.error != b.error,
      listener: (context, state) => showToast(context, state.error!),
      builder: (context, state) {
        _prefill(state);
        final step = _step;
        if (step == null) {
          return Scaffold(
            appBar: AppBar(title: Text(l.wizTitle)),
            body: state.loading
                ? const Center(child: CircularProgressIndicator())
                : ErrorView(
                    message: l.commonLoadFailed,
                    onRetry: context.read<OnboardingCubit>().load,
                  ),
          );
        }
        final isFirst = step.index == 0;
        final isLast = step == OnboardingStep.review;
        return Scaffold(
          appBar: AppBar(
            title: Text(l.wizTitle),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(28),
              child: _Progress(current: step, gaps: state.gaps, onTap: _go),
            ),
          ),
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, a) => FadeTransition(
              opacity: a,
              child: SlideTransition(
                position: Tween(
                  begin: const Offset(0.04, 0),
                  end: Offset.zero,
                ).animate(a),
                child: child,
              ),
            ),
            child: ListView(
              key: ValueKey(step),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              children: [
                _StepHeader(step: step),
                const SizedBox(height: 16),
                switch (step) {
                  OnboardingStep.profile => _profileStep(),
                  OnboardingStep.expertise => _expertiseStep(),
                  OnboardingStep.identity => _identityStep(state),
                  OnboardingStep.bank => _bankStep(state),
                  OnboardingStep.review => _reviewStep(state),
                },
              ],
            ),
          ),
          bottomNavigationBar: StickyActionBar(
            child: Row(
              children: [
                if (!isFirst) ...[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(96, 52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Radii.md),
                      ),
                    ),
                    onPressed: state.saving
                        ? null
                        : () => _go(OnboardingStep.values[step.index - 1]),
                    child: Text(l.wizBack),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: BusyButton(
                    label: isLast ? l.wizSubmit : l.wizNext,
                    icon: isLast
                        ? Icons.send_rounded
                        : Icons.arrow_forward_rounded,
                    busy: state.saving,
                    onPressed: _continue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- steps ----------------------------------------------------------------

  Widget _profileStep() {
    final l = context.l10n;
    return Form(
      key: _profileForm,
      child: SettingsCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _headline,
              maxLength: 140,
              decoration: InputDecoration(
                labelText: l.editHeadline,
                hintText: l.editHeadlineHint,
              ),
            ),
            const SizedBox(height: 4),
            TextFormField(
              controller: _bio,
              minLines: 5,
              maxLines: 10,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l.editBio,
                hintText: l.editBioHint,
                alignLabelWithHint: true,
              ),
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? l.wizBioRequired : null,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Text(l.editYears)),
                IconButton.filledTonal(
                  onPressed: _years > 0
                      ? () => setState(() => _years -= 1)
                      : null,
                  icon: const Icon(Icons.remove_rounded),
                ),
                SizedBox(
                  width: 44,
                  child: Text(
                    '$_years',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
                IconButton.filledTonal(
                  onPressed: _years < 80
                      ? () => setState(() => _years += 1)
                      : null,
                  icon: const Icon(Icons.add_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _expertiseStep() {
    final l = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final brand = context.brand;
    Widget chips(
      List<RefOption> options,
      Set<String> selected,
      ValueChanged<String> onToggle, {
      bool primary = false,
    }) {
      if (options.isEmpty) {
        return const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final o in options)
            GestureDetector(
              onLongPress: primary && selected.contains(o.code)
                  ? () {
                      HapticService.selection();
                      setState(() => _primary = o.code);
                    }
                  : null,
              child: FilterChip(
                selected: selected.contains(o.code),
                showCheckmark: false,
                avatar: primary && o.code == _primary
                    ? Icon(Icons.star_rounded, size: 16, color: brand.gold)
                    : null,
                label: Text(o.name),
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: selected.contains(o.code) ? scheme.onPrimary : null,
                ),
                selectedColor: scheme.primary,
                onSelected: (_) => onToggle(o.code),
              ),
            ),
        ],
      );
    }

    return Column(
      children: [
        SettingsCard(
          title: l.editExpertise,
          subtitle: l.editExpertiseHint,
          icon: Icons.auto_awesome_rounded,
          child: chips(
            _skillOptions,
            _skills,
            (code) => setState(() {
              if (!_skills.remove(code)) {
                _skills.add(code);
                _primary ??= code;
              } else if (_primary == code) {
                _primary = _skills.firstOrNull;
              }
            }),
            primary: true,
          ),
        ),
        SettingsCard(
          title: l.editLanguages,
          icon: Icons.translate_rounded,
          child: chips(
            _langOptions,
            _langs,
            (code) => setState(() {
              if (!_langs.remove(code)) _langs.add(code);
            }),
          ),
        ),
      ],
    );
  }

  Widget _identityStep(OnboardingState state) {
    final l = context.l10n;
    final panDone = !state.gaps.contains('kyc:pan');
    final photoDone = !state.gaps.contains('kyc:photo');
    return Column(
      children: [
        SettingsCard(
          title: l.kycPan,
          icon: Icons.credit_card_rounded,
          child: panDone && !_replacePan
              ? _DoneRow(
                  label: l.wizPanDone,
                  onReplace: () => setState(() => _replacePan = true),
                )
              : Form(
                  key: _panForm,
                  child: TextFormField(
                    controller: _pan,
                    maxLength: 10,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                      TextInputFormatter.withFunction(
                        (_, v) => v.copyWith(text: v.text.toUpperCase()),
                      ),
                    ],
                    decoration: InputDecoration(
                      labelText: l.kycPanLabel,
                      hintText: 'ABCDE1234F',
                      counterText: '',
                    ),
                    validator: (v) => kPanPattern.hasMatch((v ?? '').trim())
                        ? null
                        : l.kycPanInvalid,
                  ),
                ),
        ),
        SettingsCard(
          title: l.kycPhoto,
          subtitle: l.kycPhotoHint,
          icon: Icons.face_rounded,
          child: photoDone && !_replacePhoto
              ? _DoneRow(
                  label: l.wizPhotoDone,
                  preview: _photo,
                  onReplace: _pickPhoto,
                )
              : _PhotoPicker(
                  preview: _photo,
                  busy: state.saving,
                  onPick: _pickPhoto,
                ),
        ),
      ],
    );
  }

  Widget _bankStep(OnboardingState state) {
    final l = context.l10n;
    final added = !state.gaps.contains('bank_account');
    if (added && !_editBank) {
      return SettingsCard(
        title: l.kycBank,
        icon: Icons.account_balance_rounded,
        child: _DoneRow(
          label: l.wizBankDone,
          replaceLabel: l.wizBankUpdate,
          onReplace: () => setState(() => _editBank = true),
        ),
      );
    }
    return SettingsCard(
      title: l.kycBank,
      icon: Icons.account_balance_rounded,
      child: Form(
        key: _bankForm,
        child: Column(
          children: [
            TextFormField(
              controller: _holder,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l.kycHolder),
              validator: (v) =>
                  (v ?? '').trim().isEmpty ? l.commonRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _account,
              obscureText: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(labelText: l.kycAccount),
              validator: (v) =>
                  (v ?? '').trim().length < 6 ? l.commonRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _accountConfirm,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(labelText: l.kycAccountConfirm),
              validator: (v) => (v ?? '').trim() != _account.text.trim()
                  ? l.kycAccountMismatch
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _ifsc,
              maxLength: 11,
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                TextInputFormatter.withFunction(
                  (_, v) => v.copyWith(text: v.text.toUpperCase()),
                ),
              ],
              decoration: InputDecoration(
                labelText: l.kycIfsc,
                counterText: '',
              ),
              validator: (v) => kIfscPattern.hasMatch((v ?? '').trim())
                  ? null
                  : l.kycIfscInvalid,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bankName,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: l.kycBankName),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reviewStep(OnboardingState state) {
    final l = context.l10n;
    final brand = context.brand;
    final remaining = {...state.gaps, ...state.missing};
    const allGaps = [
      'bio',
      'skills',
      'languages',
      'kyc:pan',
      'kyc:photo',
      'bank_account',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (state.missing.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: brand.live.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Radii.sm),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline_rounded, color: brand.live),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.wizStillMissing,
                    style: TextStyle(
                      color: brand.live,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              for (final gap in allGaps)
                ListTile(
                  leading: remaining.contains(gap)
                      ? Icon(Icons.radio_button_unchecked, color: brand.live)
                      : Icon(Icons.check_circle_rounded, color: brand.online),
                  title: Text(
                    gapLabel(l, gap),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  trailing: remaining.contains(gap)
                      ? TextButton(
                          onPressed: () => _go(OnboardingStep.forGap(gap)),
                          child: Text(l.wizFix),
                        )
                      : null,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.step});

  final OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final intro = switch (step) {
      OnboardingStep.profile => l.wizProfileIntro,
      OnboardingStep.expertise => l.wizExpertiseIntro,
      OnboardingStep.identity => l.wizIdentityIntro,
      OnboardingStep.bank => l.wizBankIntro,
      OnboardingStep.review => l.wizReviewIntro,
    };
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HueIcon(hue: step.hue, icon: step.icon, size: 52, iconSize: 26),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.wizStepOf(step.index + 1, OnboardingStep.values.length),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: step.hue.end,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(step.title(l), style: theme.textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                intro,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: brand.inkMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Segmented progress; completed segments are tappable.
class _Progress extends StatelessWidget {
  const _Progress({
    required this.current,
    required this.gaps,
    required this.onTap,
  });

  final OnboardingStep current;
  final List<String> gaps;
  final ValueChanged<OnboardingStep> onTap;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        children: [
          for (final s in OnboardingStep.values)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onTap(s),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 6,
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: s == current
                          ? scheme.primary
                          : s.isDone(gaps)
                          ? brand.online
                          : brand.hairline,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DoneRow extends StatelessWidget {
  const _DoneRow({
    required this.label,
    required this.onReplace,
    this.replaceLabel,
    this.preview,
  });

  final String label;
  final String? replaceLabel;
  final Uint8List? preview;
  final VoidCallback onReplace;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Row(
      children: [
        if (preview != null)
          ClipOval(
            child: Image.memory(
              preview!,
              width: 44,
              height: 44,
              fit: BoxFit.cover,
            ),
          )
        else
          Icon(Icons.check_circle_rounded, color: brand.online, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: brand.online, fontWeight: FontWeight.w800),
          ),
        ),
        TextButton(
          onPressed: onReplace,
          child: Text(replaceLabel ?? context.l10n.wizReplace),
        ),
      ],
    );
  }
}

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({
    required this.preview,
    required this.busy,
    required this.onPick,
  });

  final Uint8List? preview;
  final bool busy;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final brand = context.brand;
    return Center(
      child: InkWell(
        onTap: busy ? null : onPick,
        customBorder: const CircleBorder(),
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: brand.sectionBg,
            border: Border.all(color: brand.hairline, width: 2),
            image: preview == null
                ? null
                : DecorationImage(
                    image: MemoryImage(preview!),
                    fit: BoxFit.cover,
                  ),
          ),
          child: busy
              ? const Center(child: CircularProgressIndicator())
              : preview == null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_a_photo_rounded,
                      size: 32,
                      color: brand.inkMuted,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.kycUploadPhoto,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: brand.inkMuted, fontSize: 12),
                    ),
                  ],
                )
              : null,
        ),
      ),
    );
  }
}
