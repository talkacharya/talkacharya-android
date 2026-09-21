import 'package:astro_kundali/astro_kundali.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/error_view.dart';
import '../cubit/prashna_detail_cubit.dart';
import 'prashna_home_page.dart' show prashnaCategoryLabel, prashnaVerdictLabel;

class PrashnaDetailPage extends StatefulWidget {
  const PrashnaDetailPage({required this.id, this.seed, super.key});
  final String id;
  final Prashna? seed;

  @override
  State<PrashnaDetailPage> createState() => _PrashnaDetailPageState();
}

class _PrashnaDetailPageState extends State<PrashnaDetailPage> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<PrashnaDetailCubit>();
    if (widget.seed != null) {
      cubit.seed(widget.seed!);
    } else {
      cubit.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.prashnaAnswerTitle)),
      body: BlocBuilder<PrashnaDetailCubit, AsyncValue<Prashna>>(
        builder: (context, state) => state.when(
          idle: _loading,
          loading: _loading,
          error: (m) => ErrorView(
            message: m,
            onRetry: () => context.read<PrashnaDetailCubit>().load(force: true),
          ),
          data: (p) => ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              Text(p.question, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                prashnaCategoryLabel(l, p.category),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              _VerdictCard(prashna: p),
              const SizedBox(height: 14),
              if (p.answer.isNotEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      p.answer,
                      style: const TextStyle(fontSize: 14, height: 1.55),
                    ),
                  ),
                ),
              if (p.reasons.isNotEmpty) ...[
                const SizedBox(height: 14),
                _ReasonsCard(prashna: p),
              ],
              const SizedBox(height: 18),
              Text(
                l.prashnaDisclaimer,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => context.go(Routes.astrologers),
                icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                label: Text(l.prashnaAskAstrologer),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _loading() => const Center(child: CircularProgressIndicator());
}

class _VerdictCard extends StatelessWidget {
  const _VerdictCard({required this.prashna});
  final Prashna prashna;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final colour = PrashnaInfo.verdictColor(prashna.verdict);
    return Card(
      color: colour.withValues(alpha: 0.08),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Icon(
              PrashnaInfo.verdictIcon(prashna.verdict),
              color: colour,
              size: 30,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    prashnaVerdictLabel(l, prashna.verdict),
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: colour,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _StrengthDots(level: prashna.strength, colour: colour),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StrengthDots extends StatelessWidget {
  const _StrengthDots({required this.level, required this.colour});
  final int level;
  final Color colour;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      for (var i = 0; i < 3; i++)
        Padding(
          padding: const EdgeInsets.only(right: 4),
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i < level ? colour : colour.withValues(alpha: 0.25),
            ),
          ),
        ),
      const SizedBox(width: 6),
      Text(
        context.l10n.prashnaConfidence(level),
        style: TextStyle(fontSize: 11.5, color: colour),
      ),
    ],
  );
}

class _ReasonsCard extends StatelessWidget {
  const _ReasonsCard({required this.prashna});
  final Prashna prashna;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          title: Text(
            context.l10n.prashnaHowRead,
            style: theme.textTheme.labelLarge,
          ),
          children: [
            for (final r in prashna.reasons)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '·  ${r.text}',
                  style: const TextStyle(fontSize: 12.5, height: 1.4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
