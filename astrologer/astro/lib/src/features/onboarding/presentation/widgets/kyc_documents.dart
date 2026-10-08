import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/api_exception.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../data/kyc_status.dart';
import '../../data/onboarding_api.dart';

final _panPattern = RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$');
final _aadhaarPattern = RegExp(r'^[0-9]{12}$');

/// The documents the team asks for, fetched and shown as one card each. Which
/// documents, and what each needs (a photo, a number, both), comes from the
/// server, so adding one in admin needs no new build of the app.
///
/// [editable] says whether a document already sent in may be replaced: yes
/// while the astrologer is still filling the application in, no once a
/// reviewer has it (a document the reviewer sent back can always be replaced).
class KycDocumentsSection extends StatefulWidget {
  const KycDocumentsSection({
    required this.editable,
    this.onChanged,
    super.key,
  });

  final bool editable;

  /// After an upload went through.
  final VoidCallback? onChanged;

  @override
  State<KycDocumentsSection> createState() => _KycDocumentsSectionState();
}

class _KycDocumentsSectionState extends State<KycDocumentsSection> {
  late Future<KycStatus> _future = getIt<OnboardingApi>().kycStatus();

  void _reload() {
    setState(() => _future = getIt<OnboardingApi>().kycStatus());
    widget.onChanged?.call();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return FutureBuilder<KycStatus>(
      future: _future,
      builder: (context, snap) {
        final status = snap.data;
        if (status == null) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: snap.hasError
                ? ErrorView(
                    message: l.commonLoadFailed,
                    onRetry: () => setState(
                      () => _future = getIt<OnboardingApi>().kycStatus(),
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          );
        }
        return KycDocumentList(
          documents: status.documents,
          editable: widget.editable,
          onUploaded: _reload,
        );
      },
    );
  }
}

/// One card per document in [documents].
class KycDocumentList extends StatelessWidget {
  const KycDocumentList({
    required this.documents,
    required this.editable,
    required this.onUploaded,
    super.key,
  });

  final List<KycDocumentState> documents;
  final bool editable;
  final VoidCallback onUploaded;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final d in documents)
        _DocumentCard(
          // A new status (sent back, replaced) starts the card afresh.
          key: ValueKey('${d.docType}:${d.status}:${d.numberLast4}'),
          document: d,
          editable: editable,
          onUploaded: onUploaded,
        ),
    ],
  );
}

class _DocumentCard extends StatefulWidget {
  const _DocumentCard({
    required this.document,
    required this.editable,
    required this.onUploaded,
    super.key,
  });

  final KycDocumentState document;
  final bool editable;
  final VoidCallback onUploaded;

  @override
  State<_DocumentCard> createState() => _DocumentCardState();
}

class _DocumentCardState extends State<_DocumentCard> {
  final _number = TextEditingController();
  bool _busy = false;
  bool _replacing = false;

  KycDocumentState get _d => widget.document;

  /// Whether the card is asking for something rather than reporting on it.
  bool get _open => _d.missing || _d.rejected || _replacing;

  @override
  void dispose() {
    _number.dispose();
    super.dispose();
  }

  /// The number as typed, or null (with a toast) when it is not a valid one.
  /// Empty is fine when the document already has its number on file.
  String? _checkedNumber() {
    final l = context.l10n;
    if (!_d.needsNumber) return '';
    final raw = _number.text.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();
    if (raw.isEmpty) {
      if (_d.numberLast4.isNotEmpty) return '';
      showToast(context, l.kycNumberNeeded);
      return null;
    }
    final bad = switch (_d.docType) {
      'pan' => !_panPattern.hasMatch(raw),
      'aadhaar' => !_aadhaarPattern.hasMatch(raw),
      _ => false,
    };
    if (bad) {
      showToast(
        context,
        _d.docType == 'pan' ? l.kycPanInvalid : l.kycAadhaarInvalid,
      );
      return null;
    }
    return raw;
  }

  Future<void> _send({bool withPhoto = true}) async {
    final l = context.l10n;
    final number = _checkedNumber();
    if (number == null) return;
    ({List<int> bytes, String filename})? file;
    if (withPhoto) {
      final x = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 2000,
        imageQuality: 88,
      );
      if (x == null || !mounted) return;
      file = (bytes: await x.readAsBytes(), filename: x.name);
    }
    if (!mounted) return;
    setState(() => _busy = true);
    try {
      await getIt<OnboardingApi>().uploadKyc(
        docType: _d.docType,
        number: number.isEmpty ? null : number,
        file: file,
      );
      if (!mounted) return;
      showToast(context, l.kycSubmitted);
      widget.onUploaded();
    } on ApiException catch (e) {
      if (mounted) {
        showToast(context, e.isNetwork ? l.commonSaveFailed : e.message);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final d = _d;
    final (icon, hue) = switch (d.docType) {
      'pan' => (Icons.credit_card_rounded, AstroPalette.career),
      'aadhaar' => (Icons.badge_rounded, AstroPalette.water),
      'bank_proof' => (Icons.account_balance_rounded, AstroPalette.air),
      'photo' => (Icons.face_rounded, AstroPalette.health),
      'certificate' => (Icons.school_rounded, AstroPalette.money),
      _ => (Icons.description_rounded, AstroPalette.career),
    };
    final (stateIcon, stateColor, stateLabel) = switch (d.status) {
      'verified' => (
        Icons.check_circle_rounded,
        const Color(0xFF30A46C),
        l.kycDocVerified,
      ),
      'rejected' => (Icons.error_rounded, brand.live, l.kycDocSentBack),
      'missing' => (
        Icons.radio_button_unchecked_rounded,
        brand.inkMuted,
        d.required ? l.kycDocNeeded : l.kycDocOptional,
      ),
      _ => (
        Icons.hourglass_top_rounded,
        const Color(0xFFB0691F),
        l.kycDocWaiting,
      ),
    };

    return SettingsCard(
      title: d.title,
      subtitle: d.help.isEmpty ? null : d.help,
      icon: icon,
      hue: hue,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(stateIcon, size: 18, color: stateColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  d.numberLast4.isEmpty || d.missing
                      ? stateLabel
                      : '$stateLabel · ${l.kycDocEndsIn(d.numberLast4)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: stateColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (!_open && widget.editable && !d.verified)
                TextButton(
                  onPressed: () => setState(() => _replacing = true),
                  child: Text(l.kycDocReplace),
                ),
            ],
          ),
          if (d.rejected && d.note.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: brand.live.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                d.note,
                style: theme.textTheme.bodyMedium?.copyWith(color: brand.live),
              ),
            ),
          ],
          if (_open) ...[
            if (d.needsNumber) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _number,
                enabled: !_busy,
                maxLength: d.docType == 'aadhaar' ? 14 : 20,
                keyboardType: d.docType == 'aadhaar'
                    ? TextInputType.number
                    : TextInputType.text,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9 ]')),
                ],
                decoration: InputDecoration(
                  labelText: l.kycDocNumber(d.title),
                  helperText: d.numberLast4.isEmpty
                      ? null
                      : l.kycDocNumberKeep(d.numberLast4),
                  counterText: '',
                ),
              ),
            ],
            const SizedBox(height: 12),
            BusyButton(
              label: !d.needsFile
                  ? l.kycSubmit
                  : d.hasFile
                  ? l.kycDocReplacePhoto
                  : l.kycDocAddPhoto,
              icon: d.needsFile
                  ? Icons.add_a_photo_rounded
                  : Icons.upload_rounded,
              busy: _busy,
              onPressed: _busy ? null : () => _send(withPhoto: d.needsFile),
            ),
          ],
        ],
      ),
    );
  }
}
