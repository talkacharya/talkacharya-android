import 'dart:async';

import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../shared/widgets/error_view.dart';
import '../cubit/prashna_cubit.dart';
import 'prashna_routes.dart';
import '../../../../core/l10n/api_error_l10n.dart';

class PrashnaHomePage extends StatefulWidget {
  const PrashnaHomePage({super.key});

  @override
  State<PrashnaHomePage> createState() => _PrashnaHomePageState();
}

class _PrashnaHomePageState extends State<PrashnaHomePage> {
  final _question = TextEditingController();
  String? _category;

  @override
  void initState() {
    super.initState();
    context.read<PrashnaCubit>().load();
  }

  @override
  void dispose() {
    _question.dispose();
    super.dispose();
  }

  Future<void> _ask(PrashnaCatalog catalog) async {
    final l = context.l10n;
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    if (_category == null || _question.text.trim().length < 5) {
      messenger.showSnackBar(SnackBar(content: Text(l.prashnaNeedQuestion)));
      return;
    }
    if (!catalog.canAfford) {
      messenger.showSnackBar(SnackBar(content: Text(l.prashnaLowBalance)));
      return;
    }
    try {
      final p = await context.read<PrashnaCubit>().ask(
        question: _question.text.trim(),
        category: _category!,
      );
      _question.clear();
      if (mounted) unawaited(router.push(PrashnaRoutes.detail(p.id), extra: p));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(localizedErrorFor(l, e))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.prashnaTitle)),
      body: BlocBuilder<PrashnaCubit, PrashnaState>(
        builder: (context, state) => RefreshIndicator(
          onRefresh: () => context.read<PrashnaCubit>().load(force: true),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              _Hero(l: l),
              const SizedBox(height: 16),
              state.catalog.when(
                idle: _loading,
                loading: _loading,
                error: (m) => ErrorView(
                  message: m,
                  onRetry: () =>
                      context.read<PrashnaCubit>().loadCatalog(force: true),
                ),
                data: (catalog) => _AskCard(
                  catalog: catalog,
                  question: _question,
                  category: _category,
                  busy: state.busy,
                  onCategory: (c) => setState(() => _category = c),
                  onAsk: () => _ask(catalog),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                l.prashnaHistory,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              state.history.when(
                idle: _loading,
                loading: _loading,
                error: (m) => ErrorView(
                  message: m,
                  onRetry: () =>
                      context.read<PrashnaCubit>().loadHistory(force: true),
                ),
                data: (items) => items.isEmpty
                    ? Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            l.prashnaNoHistory,
                            style: const TextStyle(fontSize: 13, height: 1.4),
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          for (final p in items) ...[
                            _HistoryTile(prashna: p),
                            const SizedBox(height: 8),
                          ],
                        ],
                      ),
              ),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _loading() => const Padding(
    padding: EdgeInsets.all(24),
    child: Center(child: CircularProgressIndicator()),
  );
}

class _Hero extends StatelessWidget {
  const _Hero({required this.l});
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.prashnaHeroTitle,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: scheme.onPrimaryContainer),
          ),
          const SizedBox(height: 6),
          Text(
            l.prashnaHeroBody,
            style: TextStyle(
              fontSize: 13,
              height: 1.45,
              color: scheme.onPrimaryContainer.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}

class _AskCard extends StatelessWidget {
  const _AskCard({
    required this.catalog,
    required this.question,
    required this.category,
    required this.busy,
    required this.onCategory,
    required this.onAsk,
  });

  final PrashnaCatalog catalog;
  final TextEditingController question;
  final String? category;
  final bool busy;
  final ValueChanged<String> onCategory;
  final VoidCallback onAsk;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.prashnaAbout, style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in catalog.categories)
                  ChoiceChip(
                    label: Text(prashnaCategoryLabel(l, c.value)),
                    selected: category == c.value,
                    onSelected: (_) => onCategory(c.value),
                  ),
              ],
            ),
            const SizedBox(height: 14),
            TextField(
              controller: question,
              minLines: 2,
              maxLines: 3,
              maxLength: 280,
              decoration: InputDecoration(
                hintText: l.prashnaHint,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 4),
            FilledButton(
              onPressed: busy ? null : onAsk,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: busy
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      l.prashnaAskCta('${catalog.currency} ${catalog.price}'),
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              catalog.disclaimer.isNotEmpty
                  ? catalog.disclaimer
                  : l.prashnaDisclaimer,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({required this.prashna});
  final Prashna prashna;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Card(
      child: ListTile(
        leading: Icon(
          PrashnaInfo.verdictIcon(prashna.verdict),
          color: PrashnaInfo.verdictColor(prashna.verdict),
        ),
        title: Text(
          prashna.question,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
        ),
        subtitle: Text(prashnaVerdictLabel(l, prashna.verdict)),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: () =>
            context.push(PrashnaRoutes.detail(prashna.id), extra: prashna),
      ),
    );
  }
}

String prashnaCategoryLabel(AppLocalizations l, String category) =>
    switch (category) {
      'marriage' => l.prashnaCatMarriage,
      'job' => l.prashnaCatJob,
      'promotion' => l.prashnaCatPromotion,
      'business' => l.prashnaCatBusiness,
      'property' => l.prashnaCatProperty,
      'loan_money' => l.prashnaCatMoney,
      'childbirth' => l.prashnaCatChild,
      'foreign_travel' => l.prashnaCatTravel,
      'litigation' => l.prashnaCatLitigation,
      'health' => l.prashnaCatHealth,
      'lost_item' => l.prashnaCatLost,
      'reunion' => l.prashnaCatReunion,
      _ => l.prashnaCatGeneral,
    };

String prashnaVerdictLabel(AppLocalizations l, String verdict) =>
    switch (verdict) {
      'yes' => l.prashnaVerdictYes,
      'no' => l.prashnaVerdictNo,
      'mixed' => l.prashnaVerdictMixed,
      _ => l.prashnaVerdictUnclear,
    };
