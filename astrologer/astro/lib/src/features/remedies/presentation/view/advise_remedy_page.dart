import 'dart:async';

import 'package:flutter/material.dart';
import 'package:talkacharya_ui/talkacharya_ui.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/network/friendly_error.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/settings_widgets.dart';
import '../../../consultations/data/consultation_api.dart';
import '../../../consultations/data/models/consultation.dart';
import '../../data/remedies_api.dart';
import 'suggest_remedy_page.dart';

/// Categories of remedy that cost nothing to follow. (Gemstones, rudraksha
/// and yantras are bought, and are suggested from the store.)
const kFreeRemedyCategories = [
  'mantra',
  'stotra',
  'daan',
  'vrat',
  'puja',
  'lifestyle',
];

String remedyCategoryLabel(AppLocalizations l, String key) => switch (key) {
  'mantra' => l.adviceCatMantra,
  'stotra' => l.adviceCatStotra,
  'daan' => l.adviceCatDaan,
  'vrat' => l.adviceCatVrat,
  'puja' => l.adviceCatPuja,
  'lifestyle' => l.adviceCatLifestyle,
  _ => key,
};

/// Advise a remedy that costs the customer nothing: pick one from the library
/// or write your own, and it goes to them as a message in their chat. Pops
/// `true` once sent.
class AdviseRemedyPage extends StatefulWidget {
  const AdviseRemedyPage({this.consultationId, this.customerName, super.key});

  /// Set when opened from a session: the customer is already decided.
  final String? consultationId;
  final String? customerName;

  @override
  State<AdviseRemedyPage> createState() => _AdviseRemedyPageState();
}

class _AdviseRemedyPageState extends State<AdviseRemedyPage> {
  final _title = TextEditingController();
  final _body = TextEditingController();

  List<Consultation>? _customers;
  List<RemedyTemplate>? _library;
  String _category = kFreeRemedyCategories.first;
  String? _templateId;
  late String? _consultationId = widget.consultationId;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    if (_consultationId == null) _loadCustomers();
    _loadLibrary();
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _loadCustomers() async {
    try {
      // Advice travels as a chat message, so it can only go to someone whose
      // chat is still open: a live session, or one that ended recently.
      final sessions = await getIt<ConsultationApi>().list(
        status: 'active,accepted,ended',
      );
      if (mounted) setState(() => _customers = latestPerCustomer(sessions));
    } catch (_) {
      if (mounted) setState(() => _customers = const []);
    }
  }

  Future<void> _loadLibrary() async {
    final category = _category;
    try {
      final rows = await getIt<RemediesApi>().library(category: category);
      if (mounted && category == _category) setState(() => _library = rows);
    } catch (_) {
      if (mounted) setState(() => _library = const []);
    }
  }

  void _pickCategory(String c) {
    setState(() {
      _category = c;
      _library = null;
    });
    _loadLibrary();
  }

  void _useTemplate(RemedyTemplate t) {
    setState(() {
      _templateId = t.id;
      _title.text = t.title;
      _body.text = t.caution.isEmpty ? t.body : '${t.body}\n\n${t.caution}';
    });
  }

  bool get _ready =>
      _consultationId != null &&
      _title.text.trim().isNotEmpty &&
      _body.text.trim().length >= 10;

  Future<void> _send() async {
    if (!_ready || _sending) return;
    setState(() => _sending = true);
    final l = context.l10n;
    try {
      await getIt<RemediesApi>().advise(
        consultationId: _consultationId!,
        templateId: _templateId,
        category: _category,
        title: _title.text,
        body: _body.text,
      );
      if (!mounted) return;
      showToast(context, l.adviceSent);
      Navigator.of(context).pop(true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _sending = false);
      showToast(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final brand = context.brand;
    final theme = Theme.of(context);
    final preset = widget.consultationId != null;
    final library = _library;

    return SubPageScaffold(
      title: l.adviceTitle,
      subtitle: preset && (widget.customerName ?? '').isNotEmpty
          ? l.remedySuggestFor(widget.customerName!)
          : l.adviceSubtitle,
      bottomBar: StickyActionBar(
        child: BusyButton(
          label: l.adviceSend,
          icon: Icons.send_rounded,
          busy: _sending,
          onPressed: _ready ? _send : null,
        ),
      ),
      children: [
        if (!preset) ...[
          _Label(l.remedyStepCustomer),
          if (_customers == null)
            const AppShimmer(child: SkeletonBox(height: 44, radius: 22))
          else if (_customers!.isEmpty)
            Text(l.remedyNoCustomers, style: TextStyle(color: brand.inkMuted))
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in _customers!.take(20))
                  ChoiceChip(
                    label: Text(c.customerName),
                    selected: c.id == _consultationId,
                    onSelected: (_) => setState(() => _consultationId = c.id),
                  ),
              ],
            ),
          const SizedBox(height: 18),
        ],
        _Label(l.adviceStepLibrary),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final c in kFreeRemedyCategories)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(remedyCategoryLabel(l, c)),
                    selected: c == _category,
                    onSelected: (_) => _pickCategory(c),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        if (library == null)
          const AppShimmer(child: SkeletonBox(height: 60, radius: 14))
        else if (library.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l.adviceLibraryEmpty,
              style: TextStyle(color: brand.inkMuted),
            ),
          )
        else
          for (final t in library)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: t.id == _templateId
                    ? theme.colorScheme.primary.withValues(alpha: 0.08)
                    : theme.colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Radii.md),
                  side: BorderSide(
                    color: t.id == _templateId
                        ? theme.colorScheme.primary
                        : brand.hairline,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => _useTemplate(t),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          t.title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          t.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: brand.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        const SizedBox(height: 18),
        _Label(l.adviceStepWrite),
        TextField(
          controller: _title,
          onChanged: (_) => setState(() {}),
          textCapitalization: TextCapitalization.sentences,
          maxLength: 200,
          decoration: InputDecoration(labelText: l.adviceFieldTitle),
        ),
        TextField(
          controller: _body,
          onChanged: (_) => setState(() {}),
          minLines: 4,
          maxLines: 10,
          maxLength: 3000,
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            labelText: l.adviceFieldBody,
            alignLabelWithHint: true,
          ),
        ),
        Text(
          l.adviceHowSent,
          style: theme.textTheme.bodySmall?.copyWith(color: brand.inkMuted),
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Text(
      text,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    ),
  );
}
