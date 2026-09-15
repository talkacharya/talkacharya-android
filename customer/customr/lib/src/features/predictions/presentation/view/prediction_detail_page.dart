import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_predictions/talkacharya_predictions.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/router/routes.dart';
import '../../../../core/util/async_value.dart';
import '../../../../shared/widgets/error_view.dart';
import '../cubit/prediction_detail_cubit.dart';
import 'predictions_home_page.dart' show predAreaTitle, predPeriodTitle;

class PredictionDetailPage extends StatefulWidget {
  const PredictionDetailPage({required this.id, super.key});
  final String id;

  @override
  State<PredictionDetailPage> createState() => _PredictionDetailPageState();
}

class _PredictionDetailPageState extends State<PredictionDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<PredictionDetailCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.predReadingTitle)),
      body: BlocBuilder<PredictionDetailCubit, AsyncValue<Prediction>>(
        builder: (context, state) => state.when(
          idle: _loading,
          loading: _loading,
          error: (m) => ErrorView(
            message: m,
            onRetry: () =>
                context.read<PredictionDetailCubit>().load(force: true),
          ),
          data: (p) => RefreshIndicator(
            onRefresh: () =>
                context.read<PredictionDetailCubit>().load(force: true),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: [
                _Header(prediction: p, l: l),
                const SizedBox(height: 16),
                if (p.status.isDelivered)
                  PredictionBodyView(prediction: p, disclaimer: l.predDisclaimer)
                else
                  _Pending(prediction: p, l: l),
                const SizedBox(height: 22),
                if (p.status.isDelivered)
                  FilledButton.icon(
                    onPressed: () => context.go(Routes.astrologers),
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 18),
                    label: Text(l.predAskFollowUp),
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _loading() => const Center(child: CircularProgressIndicator());
}

class _Header extends StatelessWidget {
  const _Header({required this.prediction, required this.l});
  final Prediction prediction;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: scheme.primaryContainer,
          child: Icon(
            PredictionLabels.areaIcon(prediction.area),
            color: scheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                predAreaTitle(l, prediction.area),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                predPeriodTitle(l, prediction.period),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        PredictionStatusChip(status: prediction.status),
      ],
    );
  }
}

class _Pending extends StatelessWidget {
  const _Pending({required this.prediction, required this.l});
  final Prediction prediction;
  final AppLocalizations l;

  @override
  Widget build(BuildContext context) {
    final refunded = prediction.status == PredictionStatus.refunded;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  refunded
                      ? Icons.replay_rounded
                      : Icons.edit_note_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Text(
                  refunded ? l.predRefundedTitle : l.predWritingTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              refunded
                  ? l.predRefundedBody
                  : (prediction.dueAt != null
                        ? l.predWritingEta(
                            '${prediction.dueAt!.day}/${prediction.dueAt!.month}',
                          )
                        : l.predWritingBody),
              style: const TextStyle(fontSize: 13, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
