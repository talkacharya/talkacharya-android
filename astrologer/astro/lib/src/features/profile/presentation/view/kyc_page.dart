import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/astro/onboarding_store.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../onboarding/data/onboarding_api.dart';
import '../widgets/verification_badge.dart';

final kPanPattern = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
final kIfscPattern = RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$');

/// Verification status, document re-submission and the payout bank account.
class KycPage extends StatefulWidget {
  const KycPage({super.key});
  @override
  State<KycPage> createState() => _KycPageState();
}

class _KycPageState extends State<KycPage> {
  final _api = getIt<OnboardingApi>();
  final _store = getIt<OnboardingStore>();

  final _panForm = GlobalKey<FormState>();
  final _pan = TextEditingController();
  final _bankForm = GlobalKey<FormState>();
  final _holder = TextEditingController();
  final _account = TextEditingController();
  final _accountConfirm = TextEditingController();
  final _ifsc = TextEditingController();
  final _bankName = TextEditingController();

  /// Which action is running: pan | photo | certificate | bank.
  String? _busy;

  @override
  void initState() {
    super.initState();
    _store.refresh();
  }

  @override
  void dispose() {
    for (final c in [
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

  /// Runs [action] with a busy flag; returns whether it succeeded.
  Future<bool> _run(
    String key,
    Future<void> Function() action,
    String ok,
  ) async {
    final l = context.l10n;
    setState(() => _busy = key);
    try {
      await action();
      unawaited(_store.refresh());
      if (mounted) showToast(context, ok);
      return true;
    } on ApiException catch (e) {
      if (mounted) {
        showToast(context, e.isNetwork ? l.commonSaveFailed : e.message);
      }
      return false;
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  Future<void> _submitPan() async {
    if (!_panForm.currentState!.validate()) return;
    final l = context.l10n;
    final ok = await _run(
      'pan',
      () => _api.uploadKyc(docType: 'pan', number: _pan.text.trim()),
      l.kycSubmitted,
    );
    if (ok) _pan.clear();
  }

  Future<void> _submitImage(String docType, {required double maxWidth}) async {
    final l = context.l10n;
    final x = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: maxWidth,
      imageQuality: 88,
    );
    if (x == null || !mounted) return;
    final bytes = await x.readAsBytes();
    await _run(
      docType,
      () => _api.uploadKyc(
        docType: docType,
        file: (bytes: bytes, filename: x.name),
      ),
      l.kycSubmitted,
    );
  }

  Future<void> _saveBank() async {
    if (!_bankForm.currentState!.validate()) return;
    final l = context.l10n;
    final ok = await _run(
      'bank',
      () => _api.setBankAccount(
        accountHolderName: _holder.text.trim(),
        accountNumber: _account.text.trim(),
        ifsc: _ifsc.text.trim(),
        bankName: _bankName.text.trim(),
      ),
      l.kycBankSaved,
    );
    if (ok && mounted) {
      for (final c in [_account, _accountConfirm]) {
        c.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return SubPageScaffold(
      title: l.profileKyc,
      onRefresh: _store.refresh,
      children: [
        ListenableBuilder(
          listenable: _store,
          builder: (context, _) =>
              _StatusCard(level: _store.profile?.verificationLevel ?? ''),
        ),
        SettingsCard(
          title: l.kycPan,
          subtitle: l.kycPanHint,
          icon: Icons.credit_card_rounded,
          hue: AstroPalette.career,
          child: Form(
            key: _panForm,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _pan,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 10,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                      _UpperCase(),
                    ],
                    decoration: InputDecoration(
                      labelText: l.kycPanLabel,
                      counterText: '',
                    ),
                    validator: (v) => kPanPattern.hasMatch((v ?? '').trim())
                        ? null
                        : l.kycPanInvalid,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 56,
                  child: BusyButton(
                    label: l.kycSubmit,
                    busy: _busy == 'pan',
                    icon: Icons.upload_rounded,
                    onPressed: _busy == null ? _submitPan : null,
                  ),
                ),
              ],
            ),
          ),
        ),
        _UploadCard(
          title: l.kycPhoto,
          subtitle: l.kycPhotoHint,
          icon: Icons.face_rounded,
          hue: AstroPalette.health,
          label: l.kycUploadPhoto,
          busy: _busy == 'photo',
          onTap: _busy == null
              ? () => _submitImage('photo', maxWidth: 1200)
              : null,
        ),
        _UploadCard(
          title: l.kycCertificate,
          subtitle: l.kycCertificateHint,
          icon: Icons.school_rounded,
          hue: AstroPalette.money,
          label: l.kycUploadCertificate,
          busy: _busy == 'certificate',
          onTap: _busy == null
              ? () => _submitImage('certificate', maxWidth: 2000)
              : null,
        ),
        SettingsCard(
          title: l.kycBank,
          subtitle: l.kycBankHint,
          icon: Icons.account_balance_rounded,
          hue: AstroPalette.air,
          child: Form(
            key: _bankForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                  keyboardType: TextInputType.number,
                  obscureText: true,
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
                  textCapitalization: TextCapitalization.characters,
                  maxLength: 11,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                    _UpperCase(),
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
                const SizedBox(height: 16),
                BusyButton(
                  label: l.kycBankSave,
                  icon: Icons.lock_rounded,
                  busy: _busy == 'bank',
                  onPressed: _busy == null ? _saveBank : null,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.level});

  final String level;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final s = verificationStyle(context, level);
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Radii.lg),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [s.color.withValues(alpha: 0.16), theme.colorScheme.surface],
        ),
        border: Border.all(color: s.color.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: s.color.withValues(alpha: 0.15),
            ),
            child: Icon(s.icon, color: s.color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l.kycStatus,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: context.brand.inkMuted,
                  ),
                ),
                Text(
                  verificationLabel(l, level),
                  style: theme.textTheme.titleLarge?.copyWith(color: s.color),
                ),
                const SizedBox(height: 2),
                Text(
                  verificationHint(l, level),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadCard extends StatelessWidget {
  const _UploadCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.hue,
    required this.label,
    required this.busy,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final AstroHue hue;
  final String label;
  final bool busy;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: title,
      subtitle: subtitle,
      icon: icon,
      hue: hue,
      child: OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.md),
          ),
        ),
        onPressed: busy ? null : onTap,
        icon: busy
            ? const SizedBox.square(
                dimension: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.add_photo_alternate_rounded),
        label: Text(label),
      ),
    );
  }
}

class _UpperCase extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) => newValue.copyWith(text: newValue.text.toUpperCase());
}
