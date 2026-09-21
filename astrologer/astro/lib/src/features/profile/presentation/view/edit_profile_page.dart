import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/astro/models/astro_profile.dart';
import '../../../../core/astro/onboarding_store.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/error_view.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../auth/presentation/bloc/auth/auth_bloc.dart';
import '../../data/profile_api.dart';
import '../../data/profile_models.dart';
import '../../../../core/utils/haptic_service.dart';

/// Minimum bio length the profile-strength check counts as "detailed".
const kStrongBioLength = 120;

/// Edit the public profile: cover, name, headline, bio, experience, expertise
/// and languages. Guards unsaved changes on back.
class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _api = getIt<ProfileApi>();
  final _name = TextEditingController();
  final _headline = TextEditingController();
  final _bio = TextEditingController();

  AstroProfile? _initial;
  String _initialName = '';
  int _years = 0;
  Set<String> _skills = {};
  String? _primary;
  Set<String> _langs = {};
  List<RefOption> _skillOptions = const [];
  List<RefOption> _langOptions = const [];

  String? _banner;
  bool _loading = true;
  bool _failed = false;
  bool _saving = false;
  bool _bannerBusy = false;

  @override
  void initState() {
    super.initState();
    for (final c in [_name, _headline, _bio]) {
      c.addListener(_changed);
    }
    _load();
  }

  void _changed() => setState(() {});

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _failed = false;
    });
    try {
      final results = await Future.wait([
        _api.profile(),
        _api.skillOptions(),
        _api.languageOptions(),
      ]);
      if (!mounted) return;
      final p = results[0] as AstroProfile;
      final user = context.read<AuthBloc>().state.user;
      setState(() {
        _initial = p;
        _initialName = user?.displayName ?? '';
        _name.text = _initialName;
        _headline.text = p.headline;
        _bio.text = p.bio;
        _years = p.yearsExperience;
        _skills = {for (final s in p.skills) s.slug};
        _primary = p.skills.where((s) => s.isPrimary).firstOrNull?.slug;
        _langs = {...p.languages};
        _banner = p.banner;
        _skillOptions = results[1] as List<RefOption>;
        _langOptions = results[2] as List<RefOption>;
        _loading = false;
      });
    } catch (_) {
      if (mounted) {
        setState(() {
          _loading = false;
          _failed = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _headline.dispose();
    _bio.dispose();
    super.dispose();
  }

  bool get _dirty {
    final p = _initial;
    if (p == null) return false;
    bool same(Set<String> a, Set<String> b) =>
        a.length == b.length && a.containsAll(b);
    return _name.text.trim() != _initialName ||
        _headline.text.trim() != p.headline ||
        _bio.text.trim() != p.bio ||
        _years != p.yearsExperience ||
        !same(_skills, {for (final s in p.skills) s.slug}) ||
        _primary != p.skills.where((s) => s.isPrimary).firstOrNull?.slug ||
        !same(_langs, {...p.languages});
  }

  Future<void> _save() async {
    final l = context.l10n;
    final bloc = context.read<AuthBloc>();
    setState(() => _saving = true);
    try {
      final name = _name.text.trim();
      if (name.isNotEmpty && name != _initialName) {
        final user = await _api.updateAccount(displayName: name);
        bloc.add(AuthUserUpdated(user));
        _initialName = name;
      }
      final skills = _skills.toList();
      final updated = await _api.update(
        headline: _headline.text.trim(),
        bio: _bio.text.trim(),
        yearsExperience: _years,
        skillSlugs: skills,
        primarySkillSlug: skills.isEmpty
            ? null
            : (_skills.contains(_primary) ? _primary : skills.first),
        languageCodes: _langs.toList(),
      );
      unawaited(getIt<OnboardingStore>().refresh());
      if (!mounted) return;
      setState(() {
        _initial = updated;
        _saving = false;
      });
      showToast(context, l.commonSaved);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showToast(context, e.statusCode == null ? l.commonSaveFailed : e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      showToast(context, l.commonSaveFailed);
    }
  }

  Future<void> _confirmDiscard() async {
    final l = context.l10n;
    final discard = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l.editDiscardTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l.editKeepEditing),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.editDiscard),
          ),
        ],
      ),
    );
    // Navigator.pop bypasses the PopScope guard.
    if ((discard ?? false) && mounted) Navigator.of(context).pop();
  }

  Future<void> _pickBanner() async {
    final l = context.l10n;
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      imageQuality: 85,
    );
    if (picked == null || !mounted) return;
    setState(() => _bannerBusy = true);
    try {
      final p = await _api.uploadBanner(picked.path);
      unawaited(getIt<OnboardingStore>().refresh());
      if (mounted) setState(() => _banner = p.banner);
    } catch (_) {
      if (mounted) showToast(context, l.editCoverFailed);
    } finally {
      if (mounted) setState(() => _bannerBusy = false);
    }
  }

  Future<void> _removeBanner() async {
    final l = context.l10n;
    setState(() => _bannerBusy = true);
    try {
      final p = await _api.removeBanner();
      unawaited(getIt<OnboardingStore>().refresh());
      if (mounted) setState(() => _banner = p.banner);
    } catch (_) {
      if (mounted) showToast(context, l.commonSaveFailed);
    } finally {
      if (mounted) setState(() => _bannerBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    if (_loading || _failed) {
      return Scaffold(
        appBar: AppBar(title: Text(l.profileEdit)),
        body: _failed
            ? ErrorView(message: l.commonLoadFailed, onRetry: _load)
            : const Center(child: CircularProgressIndicator()),
      );
    }
    final dirty = _dirty;
    final bioShort = kStrongBioLength - _bio.text.trim().length;

    return SubPageScaffold(
      title: l.profileEdit,
      canPop: !dirty,
      onPopBlocked: _confirmDiscard,
      bottomBar: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: dirty
            ? StickyActionBar(
                key: const ValueKey('save'),
                child: BusyButton(
                  label: l.commonSave,
                  busy: _saving,
                  onPressed: _save,
                ),
              )
            : const SizedBox.shrink(key: ValueKey('none')),
      ),
      children: [
        SettingsCard(
          title: l.editCover,
          subtitle: l.editCoverHint,
          icon: Icons.panorama_rounded,
          hue: AstroPalette.love,
          child: _BannerEditor(
            url: _banner,
            busy: _bannerBusy,
            onPick: _bannerBusy ? null : _pickBanner,
            onRemove: (_bannerBusy || _banner == null) ? null : _removeBanner,
          ),
        ),
        SettingsCard(
          title: l.editAbout,
          icon: Icons.badge_rounded,
          child: Column(
            children: [
              TextField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(labelText: l.editDisplayName),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _headline,
                maxLength: 140,
                decoration: InputDecoration(
                  labelText: l.editHeadline,
                  hintText: l.editHeadlineHint,
                ),
              ),
              const SizedBox(height: 4),
              TextField(
                controller: _bio,
                minLines: 4,
                maxLines: 10,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  labelText: l.editBio,
                  hintText: l.editBioHint,
                  alignLabelWithHint: true,
                  helperText: bioShort > 0 ? l.editBioShort(bioShort) : null,
                  helperStyle: TextStyle(color: AstroPalette.money.end),
                ),
              ),
              const SizedBox(height: 16),
              _YearsStepper(
                value: _years,
                onChanged: (v) => setState(() => _years = v),
              ),
            ],
          ),
        ),
        SettingsCard(
          title: l.editExpertise,
          subtitle: l.editExpertiseHint,
          icon: Icons.auto_awesome_rounded,
          hue: AstroPalette.money,
          child: _ChipPicker(
            options: _skillOptions,
            selected: _skills,
            primary: _primary,
            onToggle: (code) => setState(() {
              if (!_skills.remove(code)) {
                _skills.add(code);
                _primary ??= code;
              } else if (_primary == code) {
                _primary = _skills.firstOrNull;
              }
            }),
            onPrimary: (code) {
              HapticService.selection();
              setState(() => _primary = code);
            },
          ),
        ),
        SettingsCard(
          title: l.editLanguages,
          icon: Icons.translate_rounded,
          hue: AstroPalette.air,
          child: _ChipPicker(
            options: _langOptions,
            selected: _langs,
            onToggle: (code) => setState(() {
              if (!_langs.remove(code)) _langs.add(code);
            }),
          ),
        ),
      ],
    );
  }
}

class _YearsStepper extends StatelessWidget {
  const _YearsStepper({required this.value, required this.onChanged});

  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brand = context.brand;
    return Row(
      children: [
        Expanded(
          child: Text(context.l10n.editYears, style: theme.textTheme.bodyLarge),
        ),
        Container(
          decoration: BoxDecoration(
            color: brand.tint,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: value > 0 ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove_rounded),
              ),
              SizedBox(
                width: 36,
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: value < 80 ? () => onChanged(value + 1) : null,
                icon: const Icon(Icons.add_rounded),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Multi-select chips. With [onPrimary], long-press marks the primary one.
class _ChipPicker extends StatelessWidget {
  const _ChipPicker({
    required this.options,
    required this.selected,
    required this.onToggle,
    this.primary,
    this.onPrimary,
  });

  final List<RefOption> options;
  final Set<String> selected;
  final String? primary;
  final ValueChanged<String> onToggle;
  final ValueChanged<String>? onPrimary;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final brand = context.brand;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final o in options)
          GestureDetector(
            onLongPress: onPrimary != null && selected.contains(o.code)
                ? () => onPrimary!(o.code)
                : null,
            child: FilterChip(
              selected: selected.contains(o.code),
              showCheckmark: false,
              avatar: o.code == primary
                  ? Icon(Icons.star_rounded, size: 16, color: brand.gold)
                  : null,
              label: Text(
                o.code == primary
                    ? '${o.name} · ${context.l10n.editPrimary}'
                    : o.name,
              ),
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
}

/// Cover image preview (3:1, like the public profile header) with change /
/// remove actions.
class _BannerEditor extends StatelessWidget {
  const _BannerEditor({
    required this.url,
    required this.busy,
    required this.onPick,
    required this.onRemove,
  });

  final String? url;
  final bool busy;
  final VoidCallback? onPick;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final u = url;
    final placeholder = DecoratedBox(
      decoration: BoxDecoration(gradient: AstroPalette.career.linear()),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add_photo_alternate_rounded,
              color: Colors.white,
              size: 30,
            ),
            const SizedBox(height: 6),
            Text(
              l.dashTipBanner,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(Radii.md),
          child: AspectRatio(
            aspectRatio: 3,
            child: Material(
              color: brand.sectionBg,
              child: InkWell(
                onTap: onPick,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (u != null)
                      Image.network(
                        u,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => placeholder,
                      )
                    else
                      placeholder,
                    if (busy)
                      const ColoredBox(
                        color: Color(0x66000000),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (u != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: onPick,
                icon: const Icon(Icons.photo_library_rounded, size: 18),
                label: Text(l.editCoverChange),
              ),
              const SizedBox(width: 8),
              TextButton.icon(
                onPressed: onRemove,
                style: TextButton.styleFrom(foregroundColor: brand.live),
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                label: Text(l.editCoverRemove),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
