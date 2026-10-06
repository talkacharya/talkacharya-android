import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:talkacharya_predictions/talkacharya_predictions.dart';

import '../../../../shared/widgets/settings_widgets.dart';
import '../../../../core/l10n/l10n.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/util/async_value.dart';
import '../../data/predictions_repository.dart';
import '../cubit/predictions_queue_cubit.dart';

import 'package:talkacharya_ui/talkacharya_ui.dart';
class PredictionsQueuePage extends StatelessWidget {
  const PredictionsQueuePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PredictionsQueueCubit(getIt<PredictionsRepository>())..load(),
      child: const _View(),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final cubit = context.read<PredictionsQueueCubit>();
    return BlocBuilder<PredictionsQueueCubit, AsyncValue<List<Prediction>>>(
      builder: (context, state) => SubPageScaffold(
        title: l.predQueueTitle,
        subtitle: l.predQueueSubtitle,
        onRefresh: () => cubit.load(force: true),
        children: state.when(
          idle: _loading,
          loading: _loading,
          error: (m) => [
            ErrorView(message: m, onRetry: () => cubit.load(force: true)),
          ],
          data: (items) => items.isEmpty
              ? [
                  const SizedBox(height: 60),
                  EmptyState(
                    icon: Icons.inbox_outlined,
                    hue: AstroPalette.air,
                    title: l.predQueueEmptyTitle,
                    message: l.predQueueEmptyBody,
                  ),
                ]
              : [
                  for (var i = 0; i < items.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: FadeSlideIn(
                        delay: Duration(milliseconds: 50 * i),
                        child: _QueueTile(prediction: items[i]),
                      ),
                    ),
                ],
        ),
      ),
    );
  }

  static List<Widget> _loading() => const [
    SizedBox(height: 60),
    Center(child: CircularProgressIndicator()),
  ];
}

class _QueueTile extends StatelessWidget {
  const _QueueTile({required this.prediction});
  final Prediction prediction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mine = prediction.claimedAt != null;
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Icon(
            PredictionLabels.areaIcon(prediction.area),
            color: theme.colorScheme.onPrimaryContainer,
            size: 20,
          ),
        ),
        title: Text(
          '${PredictionLabels.areaTitle(prediction.area)} · '
          '${PredictionLabels.periodTitle(prediction.period)}',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
        ),
        subtitle: Text(
          [
            prediction.profileLabel,
            if (prediction.language != 'en') 'lang: ${prediction.language}',
            if (prediction.dueAt != null)
              'due ${prediction.dueAt!.day}/${prediction.dueAt!.month}',
          ].where((s) => s.isNotEmpty).join(' · '),
        ),
        trailing: mine
            ? const Chip(label: Text('Yours'))
            : const Icon(Icons.chevron_right_rounded),
        onTap: () => context.push('/predictions/${prediction.id}'),
      ),
    );
  }
}
