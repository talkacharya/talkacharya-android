import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/api_paths.dart';
import '../../../../core/di/service_locator.dart';
import '../cubit/onboarding_cubit.dart';

/// Multi-step onboarding: Profile → Expertise → Identity → Bank → Review.
/// Step completion is driven by `onboarding_gaps` from the backend.
class WizardPage extends StatelessWidget {
  const WizardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OnboardingCubit>()..load(),
      child: const _WizardView(),
    );
  }
}

class _WizardView extends StatefulWidget {
  const _WizardView();
  @override
  State<_WizardView> createState() => _WizardViewState();
}

class _WizardViewState extends State<_WizardView> {
  int _step = 0;

  final _headline = TextEditingController();
  final _bio = TextEditingController();
  final _years = TextEditingController();
  final _pan = TextEditingController();
  final _holder = TextEditingController();
  final _account = TextEditingController();
  final _ifsc = TextEditingController();
  final _bank = TextEditingController();
  final _skills = <String>{};
  final _langs = <String>{};
  String? _primarySkill;

  List<Map<String, dynamic>> _skillOptions = [];
  List<Map<String, dynamic>> _langOptions = [];

  @override
  void initState() {
    super.initState();
    _loadReference();
  }

  Future<void> _loadReference() async {
    final dio = getIt<Dio>();
    try {
      final s = await dio.get<dynamic>(ApiPaths.referenceSkills);
      final l = await dio.get<dynamic>(ApiPaths.referenceLanguages);
      setState(() {
        _skillOptions = _rows(s.data);
        _langOptions = _rows(l.data);
      });
    } catch (_) {}
  }

  List<Map<String, dynamic>> _rows(dynamic data) {
    final list = data is List ? data : (data is Map ? data['results'] : null);
    return (list as List? ?? const [])
        .map((e) => (e as Map).cast<String, dynamic>())
        .toList();
  }

  @override
  void dispose() {
    for (final c in [_headline, _bio, _years, _pan, _holder, _account, _ifsc, _bank]) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(state.error!)));
        }
        final p = state.profile;
        if (p != null && _headline.text.isEmpty) {
          _headline.text = p.headline;
          _bio.text = p.bio;
          if (p.yearsExperience > 0) _years.text = '${p.yearsExperience}';
          _skills.addAll(p.skills.map((s) => s.slug));
          _langs.addAll(p.languages);
          _primarySkill = p.skills
              .where((s) => s.isPrimary)
              .map((s) => s.slug)
              .firstOrNull;
        }
      },
      builder: (context, state) {
        final cubit = context.read<OnboardingCubit>();
        return Scaffold(
          appBar: AppBar(title: const Text('Onboarding')),
          body: state.loading
              ? const Center(child: CircularProgressIndicator())
              : Stepper(
                  currentStep: _step,
                  onStepContinue: () => _onContinue(cubit, state),
                  onStepCancel: _step == 0
                      ? null
                      : () => setState(() => _step -= 1),
                  controlsBuilder: (context, details) => Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        FilledButton(
                          onPressed:
                              state.saving ? null : details.onStepContinue,
                          child: Text(_step == 4 ? 'Submit for review' : 'Next'),
                        ),
                        const SizedBox(width: 12),
                        if (details.onStepCancel != null)
                          TextButton(
                            onPressed: details.onStepCancel,
                            child: const Text('Back'),
                          ),
                      ],
                    ),
                  ),
                  steps: [
                    _stepFor('Profile', _profileStep()),
                    _stepFor('Expertise', _expertiseStep()),
                    _stepFor('Identity (KYC)', _identityStep()),
                    _stepFor('Bank account', _bankStep()),
                    _stepFor('Review & submit', _reviewStep(state)),
                  ],
                ),
        );
      },
    );
  }

  Step _stepFor(String title, Widget content) => Step(
        title: Text(title),
        content: Align(alignment: Alignment.centerLeft, child: content),
        isActive: true,
      );

  Future<void> _onContinue(OnboardingCubit cubit, OnboardingState state) async {
    bool ok = true;
    switch (_step) {
      case 0:
        ok = await cubit.saveProfile(
          headline: _headline.text.trim(),
          bio: _bio.text.trim(),
          yearsExperience: int.tryParse(_years.text.trim()) ?? 0,
        );
      case 1:
        ok = await cubit.saveProfile(
          skillSlugs: _skills.toList(),
          primarySkillSlug: _primarySkill ?? _skills.firstOrNull,
          languageCodes: _langs.toList(),
        );
      case 2:
        if (_pan.text.trim().isNotEmpty) {
          ok = await cubit.uploadKyc(
            docType: 'pan',
            number: _pan.text.trim().toUpperCase(),
          );
        }
      case 3:
        ok = await cubit.saveBank(
          holder: _holder.text.trim(),
          accountNumber: _account.text.trim(),
          ifsc: _ifsc.text.trim(),
          bankName: _bank.text.trim(),
        );
      case 4:
        if (await cubit.submit() && mounted) {
          context.go('/onboarding');
        }
        return;
    }
    if (ok && mounted) setState(() => _step += 1);
  }

  Widget _field(TextEditingController c, String label,
          {int maxLines = 1, TextInputType? type}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          maxLines: maxLines,
          keyboardType: type,
          decoration: InputDecoration(labelText: label),
        ),
      );

  Widget _profileStep() => Column(children: [
        _field(_headline, 'Headline (e.g. "Vedic astrology, 20 years")'),
        _field(_bio, 'About you', maxLines: 4),
        _field(_years, 'Years of experience', type: TextInputType.number),
      ]);

  Widget _expertiseStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Skills'),
          Wrap(
            spacing: 8,
            children: _skillOptions.map((s) {
              final slug = s['slug'] as String;
              return FilterChip(
                label: Text(s['name'] as String? ?? slug),
                selected: _skills.contains(slug),
                onSelected: (v) => setState(() {
                  v ? _skills.add(slug) : _skills.remove(slug);
                  _primarySkill ??= _skills.firstOrNull;
                }),
              );
            }).toList(),
          ),
          if (_skills.length > 1) ...[
            const SizedBox(height: 12),
            const Text('Primary skill'),
            DropdownButton<String>(
              value: _primarySkill,
              isExpanded: true,
              items: _skills
                  .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                  .toList(),
              onChanged: (v) => setState(() => _primarySkill = v),
            ),
          ],
          const SizedBox(height: 16),
          const Text('Languages'),
          Wrap(
            spacing: 8,
            children: _langOptions.map((l) {
              final code = l['code'] as String;
              return FilterChip(
                label: Text(l['name'] as String? ?? code),
                selected: _langs.contains(code),
                onSelected: (v) => setState(
                    () => v ? _langs.add(code) : _langs.remove(code)),
              );
            }).toList(),
          ),
        ],
      );

  Widget _identityStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _field(_pan, 'PAN number'),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            icon: const Icon(Icons.photo_camera_outlined),
            label: const Text('Upload a photo of yourself'),
            onPressed: () async {
              final x = await ImagePicker().pickImage(
                source: ImageSource.gallery,
                maxWidth: 1200,
              );
              if (x == null || !mounted) return;
              final bytes = await x.readAsBytes();
              if (!mounted) return;
              await context.read<OnboardingCubit>().uploadKyc(
                    docType: 'photo',
                    file: (bytes: bytes, filename: x.name),
                  );
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Photo uploaded')),
                );
              }
            },
          ),
        ],
      );

  Widget _bankStep() => Column(children: [
        _field(_holder, 'Account holder name'),
        _field(_account, 'Account number'),
        _field(_ifsc, 'IFSC'),
        _field(_bank, 'Bank name'),
      ]);

  Widget _reviewStep(OnboardingState state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Check everything, then submit. Our team reviews profiles within '
            '1–2 business days.',
          ),
          if (state.missing.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Still missing: ${state.missing.join(', ')}',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      );
}
