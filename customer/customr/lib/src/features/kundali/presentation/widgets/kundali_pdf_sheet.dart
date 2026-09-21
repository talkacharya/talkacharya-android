import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/api_error_l10n.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/astro_palette.dart';
import '../../../../core/theme/brand_colors.dart';
import '../../../../shared/widgets/hue_widgets.dart';
import '../../../../shared/widgets/pressable.dart';
import '../../data/kundali_api.dart';
import '../../data/kundali_repository.dart';
import '../../../../core/utils/haptic_service.dart';

/// Downloads the kundali PDF and hands it to the system share sheet (save to
/// Files / Drive, WhatsApp, print…). Throws on failure.
Future<void> shareKundaliPdf({
  required String profileId,
  required String name,
  String style = 'north',
  bool full = true,
}) async {
  final bytes = await getIt<KundaliRepository>().pdf(
    profileId,
    style: style,
    full: full,
  );
  final safe = name.trim().isEmpty
      ? 'kundali'
      : name.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');
  await Share.shareXFiles([
    XFile.fromData(
      Uint8List.fromList(bytes),
      mimeType: 'application/pdf',
      name: 'kundali-$safe.pdf',
    ),
  ], subject: name);
}

/// A short user-facing reason a PDF couldn't be made.
String kundaliPdfError(BuildContext context, Object error) =>
    error is KundaliPdfUnavailable
    ? context.l10n.kPdfUnavailable
    : localizedError(context, error);

/// The "Download PDF" sheet: pick the report (full / one-page) and chart
/// style, then generate and share.
Future<void> showKundaliPdfSheet(
  BuildContext context, {
  required String profileId,
  required String name,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder: (_) => _PdfSheet(profileId: profileId, name: name),
  );
}

class _PdfSheet extends StatefulWidget {
  const _PdfSheet({required this.profileId, required this.name});
  final String profileId;
  final String name;

  @override
  State<_PdfSheet> createState() => _PdfSheetState();
}

class _PdfSheetState extends State<_PdfSheet> {
  bool _full = true;
  String _style = 'north';
  bool _busy = false;
  Object? _error;

  Future<void> _generate() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await shareKundaliPdf(
        profileId: widget.profileId,
        name: widget.name,
        style: _style,
        full: _full,
      );
      HapticService.light();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) setState(() => _error = e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final brand = context.brand;
    // Scrolls on short phones / large text, where the options + chips outgrow
    // the sheet.
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const HueIcon(
                  hue: AstroPalette.money,
                  icon: Icons.picture_as_pdf_rounded,
                  size: 46,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l.kPdfTitle,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: brand.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _Option(
              selected: _full,
              icon: Icons.library_books_rounded,
              hue: AstroPalette.career,
              title: l.kPdfFull,
              subtitle: l.kPdfFullSub,
              onTap: _busy ? null : () => setState(() => _full = true),
            ),
            const SizedBox(height: 8),
            _Option(
              selected: !_full,
              icon: Icons.description_rounded,
              hue: AstroPalette.health,
              title: l.kPdfBasic,
              subtitle: l.kPdfBasicSub,
              onTap: _busy ? null : () => setState(() => _full = false),
            ),
            const SizedBox(height: 16),
            Text(
              l.kPdfChartStyle,
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final (key, label) in [
                  ('north', l.kChNorthIndian),
                  ('south', l.kChSouthIndian),
                  ('east', l.kPdfEastIndian),
                ])
                  ChoiceChip(
                    label: Text(label),
                    selected: _style == key,
                    showCheckmark: false,
                    onSelected: _busy
                        ? null
                        : (_) => setState(() => _style = key),
                  ),
              ],
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(
                kundaliPdfError(context, _error!),
                style: theme.textTheme.bodySmall?.copyWith(color: brand.live),
              ),
            ],
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: _busy ? null : _generate,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
              icon: _busy
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    )
                  : const Icon(Icons.ios_share_rounded),
              label: Text(_busy ? l.kPdfPreparing : l.kPdfShareCta),
            ),
            const SizedBox(height: 8),
            Text(
              l.kPdfNote,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: brand.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.selected,
    required this.icon,
    required this.hue,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final AstroHue hue;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Pressable(
      child: Material(
        color: selected ? hue.tint(0.08) : theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: selected ? hue.end : context.brand.hairline,
            width: selected ? 1.6 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: hue.tint(0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 20, color: hue.end),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: context.brand.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  selected
                      ? Icons.radio_button_checked_rounded
                      : Icons.radio_button_unchecked_rounded,
                  color: selected ? hue.end : context.brand.inkMuted,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
